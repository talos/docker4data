#!/usr/bin/env python

'''
Download data based off of a data.json.  Skips download if metadata matches.

    scripts/build.py <url> <s3bucket> <tmp path>
'''

import requests
import sys
import os
import subprocess
import hashlib
import json
import logging

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)
LOGGER.addHandler(logging.StreamHandler(sys.stderr))


def shell(cmd):
    """
    Run a shell command convenience function.
    """
    LOGGER.info(cmd)
    try:
        return subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    except subprocess.CalledProcessError as err:
        LOGGER.error(err.returncode)
        LOGGER.error(err.output)
        raise


def run_script(path, tmp_dir):
    """
    Run some code and executes.  Supported are postgres and bash.
    """
    extension = path.split('.')[-1].lower()
    if extension == 'sql':
        shell('cd {dirname} && cat {path} | gosu postgres psql'.format(dirname=tmp_dir,
                                                                       path=path))
    elif extension == 'sh':
        shell('cd {dirname} && cat {path} | bash'.format(dirname=tmp_dir, path=path))
    else:
        raise Exception("Script type '{}' not supported".format(extension))


def wget_download(url, name, tmp_dir):
    """
    Download a URL and save it in file called 'name' in tmp_dir.
    """
    outfile_path = os.path.join(tmp_dir, name)
    shell("wget -q -O {} {}".format(outfile_path, url))
    return outfile_path


def get_current_digest(metadata):
    """
    Calculate a digest from existing metadata.
    """
    # No way to tell if no original metadata embedded
    if 'metadata' not in metadata:
        return ''

    # Can only tell for Socrata right now
    if 'socrata' not in metadata['metadata']:
        return ''

    try:
        socrata_metadata = requests.get(metadata['metadata']['socrata']['@id']).json()
    except ValueError:
        LOGGER.warn('bad socrata metadata for %s', metadata)

    # Can't hash the entire thing because downloadCount changes!  For now
    # just use rowsUpdatedAt, or viewLastModified
    last_modified = socrata_metadata.get(u'rowsUpdatedAt',
                                         socrata_metadata.get(u'viewLastModified'))
    if not last_modified:
        return ''

    current_digest = hashlib.sha1(unicode(last_modified)).hexdigest()
    #LOGGER.info('metadata hexdigest: %s', current_digest)
    return current_digest


def get_old_digest(s3_bucket, name):
    """
    Determine the prior digest, if any, from previous builds.
    """
    try:
        resp = shell(
            'aws s3api head-object --bucket {} --key {}'.format(s3_bucket, name))
        old_headers = json.loads(resp)
    except subprocess.CalledProcessError:
        return None

    if 'Metadata' not in old_headers:
        return None

    if 'metadata_sha1_hexdigest' not in old_headers['Metadata']:
        return None

    return old_headers['Metadata']['metadata_sha1_hexdigest']


def pgload_import(metadata, data_path, tmp_path):
    """
    Import a dataset via pgload.
    """
    options = u' '.join(
        [u'--{} "{}"'.format(x.keys()[0], x.values()[0]) for x in metadata.get('options', [])]
    )

    #if u'--with "fields terminated by' not in options:
    #    options += u' --with "fields terminated by \',\'" '

    #if u'--with "skip header' not in options:
    #    options += u' --with "skip header = 2" '

    pgload_path = os.path.join(tmp_path, 'pgloader.load')
    tablename = metadata['table']
    with open(pgload_path, 'w') as pgload:
        pgload.write('''
LOAD CSV FROM stdin
  INTO postgresql://postgres@localhost/postgres?tablename={table}
  WITH fields terminated by ',',
       skip header = 2
  SET work_mem to '64MB',
      maintenance_work_mem to '128MB';
'''.format(table=tablename))

    try:
        shell(u'gunzip -c --test {data_path}'.format(data_path=data_path))
        readfile = '| gunzip -c'
    except subprocess.CalledProcessError:
        readfile = ''

    shell(u'gosu postgres pv -f {data_path} 2>{pv_log} {readfile} | tail -n +2 | '
          u'pgloader {options} {pgload_path}'.format(
              pv_log=os.path.join(tmp_path, 'pv.log'),
              readfile=readfile, data_path=data_path, options=options,
              pgload_path=pgload_path))


def ogr2ogr_import(schema, tmp_dir):
    """
    Use ogr2ogr to load a shapefile into the database.
    """
    path = shell(u'ls {}/*/*.shp'.format(tmp_dir))
    name = u'.'.join(path.split(os.path.sep)[-1].split('.')[0:-1]).lower()
    schema_name = schema.get('schema', 'contrib')
    shell(u'gosu postgres ogr2ogr -nlt GEOMETRY -t_srs EPSG:4326 -overwrite '
          u'-f "PostgreSQL" PG:dbname=postgres {path}'.format(path=path))
    shell(u"gosu postgres psql -c 'ALTER TABLE \"{name}\" SET SCHEMA \"{schema}\"'".format(
        name=name, schema=schema_name))
    shell(u"gosu postgres psql -c 'ALTER TABLE \"{schema}\".\"{name}\" "
          u"RENAME TO \"{dataset_name}\"'".format(
              schema=schema_name, name=name, dataset_name=schema['table']))


def build(metadata_path, s3_bucket, tmp_path):
    """
    Main function.  Takes the URL of the data.json spec.

    Writes the name of the dataset to file at `/name` when done.
    """
    if not os.path.exists(tmp_path):
        os.mkdir(tmp_path)

    with open(metadata_path, 'r') as metadata_fh:
        metadata = json.load(metadata_fh)

    metadata_folder = os.path.dirname(metadata_path)
    dataset_name = metadata[u'table']
    schema_name = metadata.get(u'schema', u'contrib')
    current_digest = get_current_digest(metadata)
    old_digest = get_old_digest(s3_bucket, u'/'.join([schema_name, dataset_name]))

    # Able to verify nothing has changed, abort.
    if current_digest and old_digest and current_digest == old_digest:
        LOGGER.info(u'Current digest %s and old digest %s match, skipping %s',
                    current_digest, old_digest, dataset_name)
        sys.exit(100)  # Error exit code to stop build.sh

    # Apply docker4data requirements
    # todo actually look at versioning
    if metadata.get(u'requirements'):
        shell(u"/cli/install.sh {}".format(u' '.join(
            metadata[u'requirements'].keys())))

    shell(u"gosu postgres psql -c 'CREATE SCHEMA IF NOT EXISTS \"{schema}\"'".format(
        schema=schema_name))
    shell("gosu postgres psql -c 'DROP TABLE IF EXISTS \"{}\".\"{}\"'".format(
        schema_name, dataset_name))

    data_path = wget_download(metadata[u'data'], 'data', tmp_path)

    run_script(os.path.join(metadata_folder, 'before.sh'), tmp_path)
    run_script(os.path.join(metadata_folder, 'schema.sql'), tmp_path)

    load_type = metadata.get('load', 'pgloader')
    LOGGER.warn(load_type)
    if load_type == 'pgloader':
        pgload_import(metadata, data_path, tmp_path)
        shell(u"gosu postgres psql -c 'ALTER TABLE \"{table}\" SET SCHEMA \"{schema}\"'".format(
            table=dataset_name, schema=schema_name))

    elif load_type == 'ogr2ogr':
        shell(u'unzip {} -d {}'.format(data_path, tmp_path))
        ogr2ogr_import(metadata, tmp_path)

    run_script(os.path.join(metadata_folder, 'index.sql'), tmp_path)

    sys.stdout.write(current_digest)


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2], sys.argv[3])

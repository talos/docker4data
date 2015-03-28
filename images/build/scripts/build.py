#!/usr/bin/env python

'''
Build a docker4data container.

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
    return subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)


def run_postgres_script(script_path):
    """
    Run some psql code.
    """
    return shell('gosu postgres psql < {}'.format(script_path))


def run_remote_script(desc, tmp_dir, env_vars=None):
    """
    Run some remote code -- downloads and executes.  Supported are postgres
    and bash.
    """
    script_type = desc[u'type']
    url = desc[u'@id']
    script_name = 'script'
    script_path = os.path.join(tmp_dir, script_name)
    with open(script_path, 'w') as script:
        script.write(requests.get(url).content)

    if script_type == 'postgres':
        run_postgres_script(script_path)
    elif script_type in ('bash', ):
        env_vars = ' '.join([k + '=' + v for k, v in (env_vars or {}).items()])
        shell('cd {} && {} {} {}'.format(tmp_dir, env_vars, script_type, script_name))
    else:
        raise Exception("Script type '{}' not supported".format(script_type))


def generate_schema(table_name, schema):
    """
    Generate a schema dynamically in cases where it's not previously supplied.
    """
    columns = [u'\t"{}"\t{}'.format(c['name'], c['type']) for c in schema['columns']]
    return u'CREATE UNLOGGED TABLE {} ({})'.format(
        table_name,
        ',\n'.join(columns)
    )


def wget_download(url, name, tmp_dir):
    """
    Download a URL and save it in file called 'name'.
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

    return hashlib.sha1(requests.get(metadata['metadata']['socrata']).content).hexdigest()


def get_old_digest(s3_bucket, name):
    """
    Determine the prior digest, if any, from previous builds.
    """
    try:
        resp = shell(
            'aws s3api head-object --bucket {} --key {}'.format(s3_bucket, name))
        LOGGER.info(resp)
        old_headers = json.loads(resp)
    except subprocess.CalledProcessError:
        return None

    if 'Metadata' not in old_headers:
        return None

    if 'metadata-sha1-hexdigest' not in old_headers['Metadata']:
        return None

    return old_headers['Metadata']['metadata-sha1-hexdigest']


def pgload_import(dataset_name, data_path, load_format, tmp_dir):
    """
    Import a dataset via pgload.
    """
    pgload_path = os.path.join(tmp_dir, 'pgloader.load')
    format_type = load_format.get('type', 'csv')
    default_sep = '\t' if format_type == 'tsv' else ','
    separator = load_format.get('separator', default_sep)
    with open(pgload_path, 'w') as pgload:
        pgload.write('''
LOAD CSV FROM stdin
  INTO postgresql://postgres@localhost/postgres?{}
  WITH skip header = 1,
       fields terminated by '{}';
'''.format(dataset_name, separator))

    script = 'gosu postgres tail -n +2 {} | '.format(data_path)
    if bool(load_format.get('unique', False)):
        script += 'sort | uniq | '
    script += 'pgloader {}'.format(pgload_path)
    shell(script)


def build(url, s3_bucket, tmp_path):
    """
    Main function.  Takes the URL of the data.json spec.

    Writes the name of the dataset to file at `/name` when done.
    """
    if not os.path.exists(tmp_path):
        os.mkdir(tmp_path)

    resp = requests.get(url).json()

    dataset_name = resp[u'name']
    current_digest = get_current_digest(resp)
    old_digest = get_old_digest(s3_bucket, dataset_name)

    # Able to verify nothing has changed, abort.
    if current_digest and old_digest and current_digest == old_digest:
        LOGGER.info('Current digest %s and old digest %s match, skipping %s',
                    current_digest, old_digest, dataset_name)
        sys.exit(100)

    schema = resp[u'schema']
    if 'postgres' in schema:
        schema_path = wget_download(schema[u'postgres'][u'@id'], 'schema.sql', tmp_path)
    else:
        schema_path = os.path.join(tmp_path, 'schema.sql')
        with open(schema_path, 'w') as schema_file:
            schema_file.write(generate_schema(dataset_name, schema))
    run_postgres_script(schema_path)

    data_filename = dataset_name + '.data'
    data_path = wget_download(resp[u'data'][u'@id'], data_filename, tmp_path)

    for before in resp.get(u'before', []):
        run_remote_script(before, tmp_path, {'DATASET': data_filename})

    pgload_import(dataset_name, data_path, resp.get(u'load_format', {}), tmp_path)

    for after in resp.get(u'after', []):
        run_remote_script(after, tmp_path, {'DATASET': data_filename})

    sys.stdout.write(current_digest)


if __name__ == "__main__":
    build(sys.argv[1], sys.argv[2], sys.argv[3])

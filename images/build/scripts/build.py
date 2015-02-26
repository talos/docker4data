#!/usr/bin/env python

'''
Build a docker4data container.
'''

import requests
import sys
import os
import subprocess


def shell(cmd):
    """
    Run a shell command convenience function.
    """
    sys.stdout.write(cmd + '\n')
    return subprocess.check_call(cmd, shell=True)


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
        shell('{} && cd {} && {} {}'.format(env_vars, tmp_dir, script_type, script_name))
    else:
        raise Exception("Script type '{}' not supported".format(script_type))


def wget_download(url, name):
    """
    Download a URL and save it in file called 'name'.
    """
    outfile_path = "tmp/{}".format(name)
    shell("wget -q -O {} {}".format(outfile_path, url))
    return outfile_path


def pgload_import(dataset_name, data_path, load_format):
    """
    Import a dataset via pgload.
    """
    pgload_path = 'tmp/pgloader.load'
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


def build(url):
    """
    Main function.  Takes the URL of the data.json spec.

    Writes the name of the dataset to file at `/name` when done.
    """
    tmp_path = 'tmp'
    if not os.path.exists(tmp_path):
        os.mkdir(tmp_path)

    resp = requests.get(url).json()
    dataset_name = resp[u'name']

    schema_path = wget_download(resp[u'schema'][u'postgres'][u'@id'], 'schema.sql')
    run_postgres_script(schema_path)

    data_path = wget_download(resp[u'data'][u'@id'], dataset_name + '.data')

    for before in resp.get(u'before', []):
        run_remote_script(before, tmp_path, {'DATASET': data_path})

    pgload_import(dataset_name, data_path, resp.get(u'load_format', {}))

    for after in resp.get(u'after', []):
        run_remote_script(after, tmp_path, {'DATASET': data_path})

    with open('/name', 'w') as name_file:
        name_file.write(dataset_name)

    #is_unique = resp[u'data'].get(u'unique', False)
    #separator = resp[u'data'].get(u'separator', ',')
    #if is_unique:
    #    with open('/is_unique', 'w') as unique_file:
    #        unique_file.write('unique')
    #with open('/separator', 'w') as sep_file:
    #    sep_file.write(separator)
    #with open('/data.url', 'w') as url_file:
    #    url_file.write(data_url)
    #with open('/index.sql', 'w') as index_file:
    #    index_file.write(requests.get(index_url).content)
    #with open('/schema.sql', 'w') as schema_file:
    #    schema_file.write(requests.get(schema_url).content)


if __name__ == "__main__":
    build(sys.argv[1])

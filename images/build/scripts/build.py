#!/usr/bin/env python

'''
Build a docker4data container.
'''

import requests
import sys
import subprocess


def shell(cmd):
    """
    Run a shell command convenience function.
    """
    return subprocess.call(cmd, shell=True)


def run_postgres_script(script_path):
    """
    Run some psql code.
    """
    return shell(['gosu', 'postgres', 'psql', '<', script_path])


def run_remote_script(desc):
    """
    Run some remote code -- downloads and executes.  Supported are postgres
    and bash.
    """
    script_type = desc[u'type']
    url = desc[u'@id']
    script_path = 'tmp.before'
    with open(script_path, 'w') as script:
        script.write(requests.get(url).content)

    if script_type == 'postgres':
        run_postgres_script(script_path)
    elif script_type in ('bash', ):
        shell([script_type, script_path])
    else:
        raise Exception("Script type '{}' not supported".format(script_type))


def wget_download(url, name):
    """
    Download a URL and save it in file called 'name'.
    """
    outfile_path = "/{}".format(name)
    shell(["wget", "-q", "-O", outfile_path, url])
    return outfile_path


def pgload_import(dataset_name, data_path, load_format):
    """
    Import a dataset via pgload.
    """
    pgload_path = '/scripts/pgloader.load'
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

    script = ['gosu', 'postgres', 'tail', '-n', '+2', data_path, '|']
    if bool(load_format.get('unique', False)):
        script += ['sort', '|', 'uniq', '|']
    script += ['pgloader', pgload_path]
    shell(script)


def build(url):
    """
    Main function.  Takes the URL of the data.json spec.
    """
    resp = requests.get(url).json()
    dataset_name = resp[u'name']

    for before in resp.get(u'before', []):
        run_remote_script(before)

    schema_path = wget_download(resp[u'schema'][u'postgres'][u'@id'], 'schema.sql')
    run_postgres_script(schema_path)

    data_path = wget_download(resp[u'data'][u'@id'], dataset_name + '.data')
    pgload_import(dataset_name, data_path, resp.get(u'load_format', {}))

    for after in resp.get(u'after', []):
        run_remote_script(after)

    #is_unique = resp[u'data'].get(u'unique', False)
    #separator = resp[u'data'].get(u'separator', ',')
    #with open('/name', 'w') as name_file:
    #    name_file.write(name)
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

#!/usr/bin/env python

'''
Infer a data.json from Socrata
'''

import requests
import subprocess
import sys
import urlparse
import re
import json
import os
import logging
import time

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)
LOGGER.addHandler(logging.StreamHandler(sys.stderr))


def shell(cmd):
    """
    Run a shell command convenience function.
    """
    sys.stdout.write(cmd + '\n')
    return subprocess.check_call(cmd, shell=True)


def extract_namespace(metadata_url, is_proxy=True):
    """
    Determine the netloc regardless of whether this is proxied.
    """
    if is_proxy:
        netloc = urlparse.urlsplit(metadata_url).path.split('/')[1]
    else:
        netloc = urlparse.urlsplit(metadata_url).netloc
    return netloc


def generate_schema(tablename, columns):
    """
    Convert Socrata column definitions to docker4data.
    """
    result = []
    for column in columns:
        _type = column[u'dataTypeName'].lower()
        if _type == 'number':
            _type = 'real'
        elif _type == 'calendar_date':
            _type = 'timestamp'
        elif _type == 'money':
            _type = 'text'
        else:
            _type = 'text'
        result.append({
            "name": column[u'fieldName'].lower(),
            "type": _type
        })
    columns = [u'\t"{}"\t{}'.format(c['name'], c['type']) for c in result]
    return u'CREATE TABLE "{tablename}" (\n{columns}\n);\n'.format(
        tablename=tablename, columns=',\n'.join(columns))


def infer(metadata_url, output_root_dir): #pylint: disable=too-many-branches,too-many-statements,too-many-locals
    '''
    Main function.  Takes the URL of some Socrata metadata.

    Infer docker4data metadata from a Socrata data.json
    '''
    wait_time = 1
    while True:
        try:
            socrata_metadata = requests.get(metadata_url, headers={
                "APP_TOKEN": os.environ.get('APP_TOKEN')
            }).json()
            break
        except ValueError:
            LOGGER.warn(u'Could not extract valid JSON from %s', metadata_url)
            return
        except requests.exceptions.ConnectionError as err:
            LOGGER.warn(u'ConnectionError %s for %s, waiting %s secs',
                        err, metadata_url, wait_time)
            time.sleep(wait_time)
            wait_time *= 2

    view_type = socrata_metadata.get('viewType')
    if view_type == 'tabular':
        data_type = 'csv'
        data_url = metadata_url.replace('.json', '/rows.csv')
    elif view_type == 'blobby':
        data_type = socrata_metadata['blobMimeType'].split(';')[0]
        data_url = metadata_url.replace('api/views', 'download') \
                               .replace('.json', '/' + data_type)
    elif view_type == 'geo':
        data_type = 'shapefile'
        data_url = metadata_url.replace('api/views', 'api/geospatial') \
                               .replace('.json', '')
    elif view_type == 'href':
        data_type = 'href'
        data_url = socrata_metadata['metadata']['accessPoints'].items()[0][1]
    else:
        LOGGER.warn(u'Cannot infer table from %s, `viewType` "%s" not recognized',
                    socrata_metadata, view_type)
        return

    if 'name' not in socrata_metadata:
        LOGGER.warn(u'Cannot infer table from %s, no `name`', socrata_metadata)
        return

    namespace = os.path.join('socrata', extract_namespace(metadata_url))
    tablename = socrata_metadata['name'].lower().replace(' ', '_')
    tablename = re.sub(r'[^0-9a-z]+', '_', tablename)

    # limit to 143 characters to support encryptfs
    output_dir = os.path.join(output_root_dir, namespace, tablename[0:143])
    output_path = os.path.join(output_dir, 'data.json')
    schema_path = os.path.join(output_dir, 'schema.sql')

    if os.path.exists(output_path):
        d4d_metadata = json.load(open(output_path, 'r'))
    else:
        d4d_metadata = {
            "maintainer": {
                "@id": "https://github.com/talos/docker4data"
            },
            "metadata": {}
        }
        try:
            os.makedirs(output_dir)
        except OSError:
            pass

    d4d_metadata[u"name"] = socrata_metadata[u'name']
    d4d_metadata[u"table"] = tablename
    if u"schema" in d4d_metadata:
        del d4d_metadata[u"schema"]

    if data_type == u"href":
        if data_url.endswith(".xml"):
            data_type = u"application/xml"
        elif data_url.endswith(".pdf"):
            data_type = u"application/pdf"
        elif data_url.endswith(".xls") or data_url.endswith(".xlsx"):
            data_type = u"vnd.ms-excel"
        else:
            pass

    d4d_metadata[u"data"] = data_url
    if data_type == u"csv":
        pass
    elif data_type == u"shapefile":
        d4d_metadata[u"load"] = u"pgloader"
    elif data_type == u"application/pdf":
        d4d_metadata[u"load"] = u"pdftotext"
    elif data_type == u"vnd.ms-excel":
        d4d_metadata[u"load"] = u"TODO: excel"
    elif data_type == u"application/xml":
        d4d_metadata[u"load"] = u"TODO: xml"
    else:
        d4d_metadata[u"load"] = u"TODO: {}".format(data_type)

    if u'description' not in d4d_metadata and u'description' in socrata_metadata:
        d4d_metadata[u'description'] = socrata_metadata[u'description']

    if data_type == 'csv':
        schema = generate_schema(tablename, socrata_metadata[u'columns'])
    else:
        schema = None

    if u'metadata' not in d4d_metadata:
        d4d_metadata[u"metadata"] = {}
    d4d_metadata[u"metadata"][u"socrata"] = {
        "@id": metadata_url
    }
    if u'attribution' in socrata_metadata:
        d4d_metadata[u"metadata"][u"attribution"] = socrata_metadata[u"attribution"]
    if u"category" in socrata_metadata:
        d4d_metadata[u"metadata"][u"category"] = socrata_metadata[u"category"]
    if u"description" in socrata_metadata:
        d4d_metadata[u"metadata"][u"description"] = socrata_metadata[u"description"]

    with open(output_path, 'w') as output_file:
        json.dump(d4d_metadata, output_file, indent=2, sort_keys=True)

    if schema is not None:
        with open(schema_path, 'w') as schema_file:
            schema_file.write(schema)

    LOGGER.info(u'Inferred "%s" from "%s"', output_path, metadata_url)


if __name__ == "__main__":
    infer(sys.argv[1], sys.argv[2])

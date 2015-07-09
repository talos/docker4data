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


def generate_schema(columns):
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
            _type = 'real'
        else:
            _type = 'text'
        result.append({
            "name": column[u'fieldName'].lower(),
            "type": _type
        })
    return result


def infer(metadata_url, output_root_dir):
    '''
    Main function.  Takes the URL of some Socrata metadata.

    Infer docker4data metadata from a Socrata data.json
    '''
    socrata_metadata = requests.get(metadata_url, headers={
        "APP_TOKEN": os.environ.get('APP_TOKEN')
    }).json()

    view_type = socrata_metadata.get('viewType')
    if view_type == 'tabular':
        data_type = 'csv'
        data_url = metadata_url.replace('.json', '/rows.csv')
    elif view_type == 'blobby':
        data_type = socrata_metadata['blobMimeType']
        data_url = metadata_url.replace('api/views', 'download') \
                               .replace('.json', data_type)
    elif view_type == 'href':
        pass
    elif view_type == 'geo':
        data_type = 'shapefile'
        data_url = metadata_url.replace('api/views', 'api/geospatial') \
                               .replace('.json', '')
    else:
        LOGGER.warn(u'Cannot infer table from %s, `viewType` "%s" not recognized', socrata_metadata, view_type)
        return

    if 'name' not in socrata_metadata:
        LOGGER.warn(u'Cannot infer table from %s, no `name`', socrata_metadata)
        return

    namespace = os.path.join('socrata',  extract_namespace(metadata_url))
    tablename = socrata_metadata['name'].lower().replace(' ', '_')
    tablename = re.sub(r'[^0-9a-z]+', '_', tablename)[0:62]

    output_dir = os.path.join(output_root_dir, namespace, tablename)
    output_path = os.path.join(output_dir, 'data.json')

    if os.path.exists(output_path):
        d4d_metadata = json.load(open(output_path, 'r'))
    else:
        d4d_metadata = {
            "@id": u"https://raw.githubusercontent.com/talos/docker4data/"
                   u"master/data/{}/data.json".format(tablename),
            "maintainer": {
                "@id": "https://github.com/talos/docker4data"
            },
            "data": {},
            "schema": {},
            "metadata": {}
        }
        try:
            os.makedirs(output_dir)
        except OSError:
            pass

    d4d_metadata[u"name"] = socrata_metadata[u'name']
    d4d_metadata[u"tableName"] = tablename
    d4d_metadata[u"schemaName"] = namespace

    d4d_metadata[u"data"][u"@id"] = data_url
    d4d_metadata[u"data"][u"type"] = data_type

    if u'description' not in d4d_metadata and u'description' in socrata_metadata:
        d4d_metadata[u'description'] = socrata_metadata[u'description']

    if view_type == 'tabular':
        d4d_metadata[u"schema"][u"columns"] = generate_schema(socrata_metadata[u'columns'])

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

    LOGGER.info(u'Inferred "%s" from "%s"', output_path, metadata_url)


if __name__ == "__main__":
    infer(sys.argv[1], sys.argv[2])

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
    Determine a proper namespace for dataset based off of the metadata url.

    For example:

        `https://data.somervillema.gov/api/views/id.json` -> somervillema
        `https://cookcounty.socrata.com/api/views/id.json` -> cookcounty
        `https://opendata.go.ke/api/views/id.json` -> opendata_go_ke
        `https://data.cityofnewyork.us/api/views/id.json` -> cityofnewyork
        `https://electionsdata.kingcounty.gov/api/views/id.json` -> electionsdata_kingcounty

    """
    if is_proxy:
        netloc = urlparse.urlsplit(metadata_url).path.split('/')[1]
    else:
        netloc = urlparse.urlsplit(metadata_url).netloc
    netloc = re.sub(r'(^data\.|\.gov$|\.edu$|\.com$|\.org$|\.?socrata\.?|^www\.|\.us$)', '', netloc)
    return netloc.replace('.', '_').lower()


def generate_schema(columns):
    """
    Convert Socrata column definitions to docker4data.
    """
    result = []
    for column in columns:
        _type = column[u'dataTypeName'].lower()
        if _type == 'number':
            _type = 'real'
            #if 'cachedContents' in column and 'largest' in column['cachedContents']:
            #    try:
            #        largest = int(column['cachedContents']['largest'])
            #        if largest >= pow(2, 32):
            #            _type = 'bigint'
            #        elif largest >= pow(2, 16):
            #            _type = 'integer'
            #        elif largest >= pow(2, 8):
            #            _type = 'smallint'
            #        else:
            #            _type = 'integer'
            #    except ValueError:
            #        pass
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
    socrata_metadata = requests.get(metadata_url).json()
    data_url = metadata_url.replace('.json', '/rows.csv')

    if 'name' not in socrata_metadata:
        LOGGER.warn(u'Cannot infer table from %s, no `name`', socrata_metadata)
        return

    namespace = extract_namespace(metadata_url)
    name = u'socrata_{}_{}'.format(namespace,
                                   socrata_metadata['name'].lower().replace(' ', '_'))
    name = re.sub(r'[^0-9a-z]+', '_', name)[0:62]

    output_dir = os.path.join(output_root_dir, name)
    output_path = os.path.join(output_dir, 'data.json')

    if os.path.exists(output_path):
        d4d_metadata = json.load(open(output_path, 'r'))
    else:
        d4d_metadata = {
            "@id": u"https://raw.githubusercontent.com/talos/docker4data/"
                   u"master/data/{}/data.json".format(name),
            "name": name,
            "maintainer": {
                "@id": "https://github.com/talos/docker4data"
            },
            "data": {
                "@id": data_url
            },
            "schema": {},
            "metadata": {}
        }
        try:
            os.makedirs(output_dir)
        except OSError:
            pass

    d4d_metadata[u"schema"][u"columns"] = generate_schema(socrata_metadata[u'columns'])
    if u'metadata' not in d4d_metadata:
        d4d_metadata[u"metadata"] = {}
    d4d_metadata[u"metadata"][u"socrata"] = metadata_url

    with open(output_path, 'w') as output_file:
        json.dump(d4d_metadata, output_file, indent=2, sort_keys=True)


if __name__ == "__main__":
    infer(sys.argv[1], sys.argv[2])

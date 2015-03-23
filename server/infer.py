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
            _type = 'integer'
            if 'cachedContents' in column:
                largest = int(column['cachedContents']['largest'])
                if largest >= pow(2, 32):
                    _type = 'bigint'
                elif largest >= pow(2, 16):
                    _type = 'integer'
                elif largest >= pow(2, 8):
                    _type = 'smallint'
                else:
                    _type = 'tinyint'
        if _type == 'calendar_date':
            _type = 'datetime'
        if _type == 'money':
            _type = 'real'
        result.append({
            "name": column[u'fieldName'].lower(),
            "type": _type
        })
    return result


def infer(metadata_url):
    '''
    Main function.  Takes the URL of some Socrata metadata.

    Infer docker4data metadata from a Socrata data.json
    '''
    socrata_metadata = requests.get(metadata_url).json()
    data_url = metadata_url.replace('.json', '/rows.csv')
    namespace = extract_namespace(metadata_url)
    name = u'socrata_{}_{}'.format(namespace,
                                   socrata_metadata['name'].lower().replace(' ', '_'))
    name = re.sub(r'[^0-9a-z]+', '_', name)
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
        "schema": generate_schema(socrata_metadata[u'columns'])
    }
    sys.stdout.write(json.dumps(d4d_metadata, indent=2))


if __name__ == "__main__":
    infer(sys.argv[1])

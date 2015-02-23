#!/usr/bin/env python

import requests
import sys


def build(url):
    resp = requests.get(url).json
    data_url = resp[u'data'][u'@id']
    index_url = resp[u'after'][u'@id']
    schema_url = resp[u'schema'][u'postgres'][u'@id']
    name = resp[u'name']
    with open('/name', 'w') as name_file:
        name_file.write(name)
    with open('/data.url', 'w') as url_file:
        url_file.write(data_url)
    with open('/index.sql') as index_file:
        index_file.write(requests.get(index_url).data)
    with open('/schema.sql') as schema_file:
        schema_file.write(requests.get(schema_url).data)


if __name__ == "__main__":
    build(sys.argv[1])

#!/usr/bin/env python

import requests
import sys


def build(url):
    resp = requests.get(url).json()
    data_url = resp[u'data'][u'@id']
    index_url = resp[u'after'][0][u'@id']
    schema_url = resp[u'schema'][u'postgres'][u'@id']
    is_unique = resp[u'data'].get(u'unique', False)
    separator = resp[u'data'].get(u'separator', ',')
    name = resp[u'name']
    with open('/name', 'w') as name_file:
        name_file.write(name)
    if is_unique:
        with open('/is_unique', 'w') as unique_file:
            unique_file.write('unique')
    with open('/separator', 'w') as sep_file:
        sep_file.write(separator)
    with open('/data.url', 'w') as url_file:
        url_file.write(data_url)
    with open('/index.sql', 'w') as index_file:
        index_file.write(requests.get(index_url).content)
    with open('/schema.sql', 'w') as schema_file:
        schema_file.write(requests.get(schema_url).content)


if __name__ == "__main__":
    build(sys.argv[1])

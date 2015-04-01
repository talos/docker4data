#!/bin/bash

#curl -XGET 'http://127.0.0.1:9200/socrata/metadata/_search' \
#  -d '{"query":{"match_all":{}}}'

#curl -XGET 'http://127.0.0.1:9200/socrata/metadata/_search?pretty=true' -d @query.json

curl -XGET 'http://127.0.0.1:9200/docker4data/metadata/_search?pretty=true' -d @query.json

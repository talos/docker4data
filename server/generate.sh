#!/bin/bash -e

PORTALS_URL=http://www.opendatacache.com/logs/status.log

for portal in $(curl -k -s -S ${PORTALS_URL} | cut -f 1); do
  portal_url=http://www.opendatacache.com/logs/$portal/summary.log
  echo $portal_url
  for id in $(curl -k -s -S $portal_url | grep -P '^200|^201' | cut -f 2); do
    dataset_url=http://www.opendatacache.com/${portal}/api/views/${id}.json
    python infer.py $dataset_url ../data
  done
done

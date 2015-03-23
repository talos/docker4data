#!/bin/bash -e

PORTALS_URL=https://raw.githubusercontent.com/talos/opendatacache/master/site/portals.txt

for portal in $(curl -k -s -S ${PORTALS_URL}); do
  portal_url=http://www.opendatacache.com/$portal/data.json
  for id in $(curl -k -s -S $portal_url | grep -Po '"identifier":(.*?[^\\])",' | grep -Po '[\d\w]{4}-[\d\w]{4}'); do
    if [ $id == "data.json" ]; then
      continue
    fi
    dataset_url=http://www.opendatacache.com/${portal}/api/views/${id}.json
    python infer.py $dataset_url ../data
    break
  done
  #echo $portal
done

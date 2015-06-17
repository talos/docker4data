#!/bin/bash -e

### Regenerate JSON in git repo from socrata all socrata data portals, or only
### the one specified if one is specified

PORTALS_URL=http://www.opendatacache.com/logs/status.log

function generate_portal {
  portal=$1
  portal_url=http://www.opendatacache.com/logs/$portal/summary.log
  for id in $(wget -O - -q $portal_url | grep -P '^200|^201' | cut -f 2); do
    dataset_url=http://www.opendatacache.com/${portal}/api/views/${id}.json
    python /scripts/infer.py $dataset_url /docker4data/data
  done
}

if [ $1 ]; then
  generate_portal $1
else
  for portal in $(wget -O - -q ${PORTALS_URL} | cut -f 1); do
    generate_portal $portal
  done
fi

#!/bin/bash -e

### Regenerate JSON in git repo from socrata data portals

PORTALS_URL=http://www.opendatacache.com/logs/status.log

mkdir -p /git
if [ -e /git/docker4data ]; then
  cd /git/docker4data
  git fetch origin
  git clean -f
  git checkout -- .
  git checkout origin/master
  git checkout -B master
else
  cd /git
  git clone git@github.com:talos/docker4data
fi

function generate_portal {
  portal_url=$1
  echo $portal_url
  for id in $(wget -O - -q $portal_url | grep -P '^200|^201' | cut -f 2); do
    dataset_url=http://www.opendatacache.com/${portal}/api/views/${id}.json
    python /scripts/infer.py $dataset_url /git/docker4data/data
  done
}

for portal in $(wget -O - -q ${PORTALS_URL} | cut -f 1); do
  generate_portal http://www.opendatacache.com/logs/$portal/summary.log
done

#!/bin/bash -e

docker rm -f docker4data
docker run -p 54321:5432 -d \
  -v $(pwd)/cli:/cli \
  --name docker4data \
  thegovlab/docker4data:latest \
  /bin/bash -c /scripts/docker-entrypoint.sh 2>/dev/null || :

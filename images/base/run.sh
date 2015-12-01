#!/bin/bash -e

docker rm -f docker4data || :
docker run -p 54321:5432 -d \
  -v ${PWD}/cli:/cli \
  -v ${HOME}/.d4d/data:/data/ \
  --name docker4data \
  -e TERM=$TERM \
  thegovlab/docker4data:latest \
  /bin/bash -c /scripts/docker-entrypoint.sh 2>/dev/null || :

#!/bin/bash

docker run -d --name docker4data-build \
  -v $(pwd)/keys/.ssh:/root/.ssh \
  -v $(pwd)/keys/.aws:/root/.aws \
  -v $(pwd)/scripts:/scripts \
  thegovlab/docker4data-build /scripts/postgres.sh

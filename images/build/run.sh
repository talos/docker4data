#!/bin/bash

docker run -d --name docker4data-build \
  -v /root/.ssh:$(pwd)/keys/.ssh \
  -v /root/.aws:$(pwd)/keys/.aws \
  -v /scripts:$(pwd)/scripts \
  thegovlab/docker4data-build /scripts/postgres.sh

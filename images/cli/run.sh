#!/bin/bash

docker rm -f docker4data-cli || :

docker run \
  -p 9200:9200 \
  --name docker4data-cli -d thegovlab/docker4data-cli elasticsearch

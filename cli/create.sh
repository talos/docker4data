#!/bin/bash -e

# Create a new, blank docker4data container

docker pull thegovlab/docker4data:latest
# Require user approve deletion of prior container
# docker rm -f docker4data || :

docker run -p 54321:5432 -d --name docker4data ${VOLUMES_FROM} thegovlab/docker4data

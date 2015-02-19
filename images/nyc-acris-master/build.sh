#!/bin/bash

PWD=$(pwd)

# First, load up a psql ready docker4data linked up to a dietfs export data container
BUILD_CONTAINER=$(docker run -d -v ${PWD}:/csv thegovlab/docker4data-buildbase /scripts/postgres.sh)

sleep 1

docker exec ${BUILD_CONTAINER} ls -la /csv
docker exec ${BUILD_CONTAINER} /bin/bash /scripts/load.sh -u -s ',' acris_master

#BUILD_IMAGE=$(docker commit ${BUILD_CONTAINER})
#echo build image: ${BUILD_IMAGE}

#
#echo build container: ${BUILD_CONTAINER}
#docker exec ${BUILD_CONTAINER} touch /output/foo
#docker exec ${BUILD_CONTAINER} ls /output
#
##BUILD_IMAGE=$(docker commit ${BUILD_CONTAINER})
##echo build image: ${BUILD_IMAGE}
##
##docker run -i ${BUILD_IMAGE} sh
##
#DATA_IMAGE=$(docker commit ${DATA_CONTAINER})
#echo data image: ${DATA_IMAGE}
#
#DATA_CONTAINER=$(docker run -d ${DATA_IMAGE})
#docker exec -i ${DATA_CONTAINER} sh
#
#docker ps | wc -l

#docker rm -f ${DATA_CONTAINER}
#docker rm -f ${BUILD_CONTAINER}

# Import the csv using the supplied schema

# Dump it to the dietfs export image, and save that as a data image

#!/bin/bash

PWD=$(pwd)

# First, load up a psql ready docker4data-build to download and import data
BUILD_CONTAINER=$(docker run -d -v ${PWD}:/share thegovlab/docker4data-build /scripts/postgres.sh)

#sleep 1

# Import the csv using the supplied schema
docker exec ${BUILD_CONTAINER} /bin/bash /scripts/load.sh -u -s ',' acris_master

# Dump it to the dietfs export image, and save that as a data image
docker exec ${BUILD_CONTAINER} chown postgres:postgres /share
docker exec ${BUILD_CONTAINER} gosu postgres pg_dump -F c -Z 9 -t acris_master -f /share/dump postgres

docker build -t thegovlab/docker4data-nyc-acris-master .

# to be used down the line...
#DATA_CONTAINER=$(docker run -v /share ${DATA_IMAGE})
#time gosu postgres pg_restore -d postgres /share/dump > log 2>error

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



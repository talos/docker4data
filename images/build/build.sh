#!/bin/bash

if [ ! $1 ]; then
  echo 'Must specify URL of data.json to build as first argument.

    ./build.sh $URL

'
  exit 1
fi

docker build -t thegovlab/docker4data-build .

PWD=$(pwd)
mkdir -p share

# First, load up a psql ready docker4data-build to download and import data
BUILD_CONTAINER=$(docker run -d -v ${PWD}/share:/share thegovlab/docker4data-build /scripts/postgres.sh)

# Import the csv using the supplied schema
echo $1
docker exec ${BUILD_CONTAINER} python /scripts/build.py $1
docker exec ${BUILD_CONTAINER} /bin/bash /scripts/load.sh

# Dump it to the dietfs export image, and save that as a data image
docker exec ${BUILD_CONTAINER} chown postgres:postgres /share
docker exec ${BUILD_CONTAINER} /bin/bash /scripts/dump.sh
NAME=$(docker exec ${BUILD_CONTAINER} cat /name)

mkdir -p tmp
TMP_DOCKERFILE=tmp/Dockerfile-${NAME}
cat "Dockerfile-export" | sed "s/dataset/${NAME}/g" > ${TMP_DOCKERFILE}
docker build -t thegovlab/docker4data-${NAME} -f Dockerfile-export .
docker push thegovlab/docker4data-${NAME}


# to be used down the line...
#DATA_CONTAINER=$(docker run -v /share ${DATA_IMAGE})
#time gosu postgres pg_restore -d postgres /share/dump > log 2>error

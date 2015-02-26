#!/bin/bash -e

if [ ! $1 ]; then
  echo 'Must specify URL of data.json to build as first argument.

    ./build.sh $URL

'
  exit 1
fi

PWD=$(pwd)
TMPDIR=$(mktemp -d /tmp/docker4data-build.XXXX)

# First, load up a psql ready docker4data-build to download and import data
BUILD_CONTAINER=$(docker run -d -v ${PWD}/$TMPDIR:/share thegovlab/docker4data-build /scripts/postgres.sh)

# Import the csv using the supplied schema
docker exec ${BUILD_CONTAINER} python /scripts/build.py $1

NAME=$(docker exec ${BUILD_CONTAINER} cat /name)
echo $NAME

# Dump it to the dietfs export image, and save that as a data image
docker exec ${BUILD_CONTAINER} chown postgres:postgres /share
docker exec ${BUILD_CONTAINER} /bin/bash /scripts/dump.sh $NAME

mkdir -p tmp  # because tmp dockerfile must be in build context
TMP_DOCKERFILE=tmp/Dockerfile-${NAME}
cat "Dockerfile" | \
  sed "s!dataset!${NAME}!g" | \
  sed "s!share_path!${TMPDIR}!g" \
  > ${TMP_DOCKERFILE}

# Ensure name is not too long for docker hub
TAG=thegovlab/d4d-$(echo ${NAME} | cut -c 1-26)

docker build -t ${TAG} -f ${TMP_DOCKERFILE} .
rm -rf $TMPDIR

docker push ${TAG}


# to be used down the line...
#DATA_CONTAINER=$(docker run -v /share ${DATA_IMAGE})
#time gosu postgres pg_restore -d postgres /share/dump > log 2>error

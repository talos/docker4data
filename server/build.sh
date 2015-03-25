#!/bin/bash -e

if [ ! $1 ]; then
  echo 'Must specify name of data.json in github.com/talos/docker4data to build
as first argument.

    ./build.sh $NAME

'
  exit 1
fi

S3_BUCKET=s3://data.docker4data.com/sqldump

if [[ -n $(aws s3 ls $S3_BUCKET/$1) ]]; then
  echo "Already built $1"
  exit 0
fi

PWD=$(pwd)
TMPDIR=$(mktemp -d /tmp/docker4data-build.XXXX)

# First, load up a psql ready docker4data-build to download and import data
BUILD_CONTAINER=$(docker run -d -v $TMPDIR:/share thegovlab/docker4data-build /scripts/postgres.sh)

# Make sure postgres is running before continuing
while : ; do
  docker exec ${BUILD_CONTAINER} gosu postgres psql -c '\q' > /dev/null 2>&1 && break || echo "Waiting for postgres to start up"
  sleep 0.2
done

# Import the csv using the supplied schema
data_json=https://raw.githubusercontent.com/talos/docker4data/master/data/$1/data.json
echo $data_json
docker exec ${BUILD_CONTAINER} python /scripts/build.py $data_json

NAME=$(docker exec ${BUILD_CONTAINER} cat /name)
echo $NAME

# Dump it to the dietfs export image, and save that as a data image
docker exec ${BUILD_CONTAINER} chown postgres:postgres /share
docker exec ${BUILD_CONTAINER} chmod a+rwx /share
docker exec ${BUILD_CONTAINER} /bin/bash /scripts/dump.sh $NAME

aws s3 cp --acl public-read $TMPDIR/$NAME $S3_BUCKET/$NAME

docker stop ${BUILD_CONTAINER}
docker rm -f ${BUILD_CONTAINER}
#rm -rf $TMPDIR/*

#  mkdir -p tmp  # because tmp dockerfile must be in build context
#  TMP_DOCKERFILE=tmp/Dockerfile-${NAME}
#  cat "Dockerfile" | \
#    sed "s!dataset!${NAME}!g" | \
#    sed "s!share_path!${TMPDIR}!g" \
#    > ${TMP_DOCKERFILE}
#
#  # Ensure name is not too long for docker hub
#  TAG=thegovlab/d4d-$(echo ${NAME} | cut -c 1-26)
#
#  docker build -t ${TAG} -f ${TMP_DOCKERFILE} .
#  rm -rf $TMPDIR
#
#  docker push ${TAG}


# to be used down the line...
#DATA_CONTAINER=$(docker run -v /share ${DATA_IMAGE})
#time gosu postgres pg_restore -d postgres /share/dump > log 2>error

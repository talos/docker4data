#!/bin/bash -e

for DATASET in $@; do
  docker rm $DATASET || :
  #   IMAGE=thegovlab/docker4data-$DATASET
  #   docker pull $IMAGE &
done

echo 'Waiting for data to pull.'
wait

VOLUMES_FROM=''
for DATASET in $@; do
  IMAGE=thegovlab/docker4data-$DATASET
  DATA_CONTAINER=$(docker run --name $DATASET -d -v /$DATASET $IMAGE sh)
  VOLUMES_FROM="$VOLUMES_FROM --volumes-from $DATASET"
done

echo "docker run -d --name docker4data --volumes-from $@"
docker run -d --name docker4data $VOLUMES_FROM thegovlab/docker4data

for DATASET in $@; do
  docker exec docker4data ls /$DATASET/dump
  cmd="gosu postgres pg_restore -v -d postgres /$DATASET/dump"
  echo $cmd
  #docker exec -d docker4data $cmd
done

docker exec -i docker4data /bin/bash

docker rm -f docker4data

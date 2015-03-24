#!/bin/bash -e

DUMPS=http://data.docker4data.com.s3-website-us-east-1.amazonaws.com/sqldump

#docker pull thegovlab/docker4data:latest
docker rm -f docker4data || :

DATASETS=$@
#for DATASET in ${DATASETS}; do
#  docker rm -f ${DATASET} || :
#  IMAGE=thegovlab/d4d-$(echo ${DATASET} | cut -c 1-26)
#  docker pull ${IMAGE}:latest &
#done
#
#echo 'Waiting for data to pull.'
#wait

#VOLUMES_FROM=''
#for DATASET in ${DATASETS}; do
#  IMAGE=thegovlab/d4d-$(echo ${DATASET} | cut -c 1-26)
#  DATA_CONTAINER=$(docker run --name ${DATASET} -d -v /${DATASET} ${IMAGE} sh)
#  VOLUMES_FROM="${VOLUMES_FROM} --volumes-from ${DATASET}"
#done

echo "Running docker4data container to import data"
docker run -p 54321:5432 -d --name docker4data thegovlab/docker4data

for DATASET in ${DATASETS}; do
  docker exec docker4data mkdir -p /$DATASET/
  docker exec docker4data wget -O /$DATASET/dump $DUMPS/$DATASET &
done

echo 'Waiting for data to download.'
wait

while : ; do
  docker exec docker4data gosu postgres psql -c '\q' > /dev/null 2>&1 && break || echo "Waiting for postgres to start up"
  sleep 0.2
done

for DATASET in $DATASETS; do
  echo "Restoring $DATASET"
  docker exec docker4data /bin/bash -c "/usr/bin/time -o /${DATASET}.time gosu postgres pg_restore -v -d postgres /$DATASET/dump > /${DATASET}.log 2>&1 &" &
done

echo "Waiting for dataset imports"
while : ; do
  sleep 2
  FINISHED=''
  for DATASET in $DATASETS; do
    TIME=$(docker exec docker4data cat /${DATASET}.time) || continue
    if [ "$TIME" ] ; then
      FINISHED="$FINISHED $DATASET"
    fi
  done
  if [ " ${DATASETS}" == "${FINISHED}" ] ; then
    echo "Finished importing '${FINISHED}' datasets"
    break
  else
    echo "Imported '${FINISHED}' datasets, waiting for more"
  fi
done

if [ $(which psql) ]; then
  echo "to drop in, enter

     PGPASSWORD=docker4data psql -h localhost -p 54321 -U postgres postgres

  "
else
  echo "to drop in, enter

     docker exec -i docker4data gosu postgres psql

  "
fi

#
#docker exec -i docker4data /bin/bash

#docker rm -f docker4data

#!/bin/bash -e

docker pull thegovlab/docker4data
docker rm -f docker4data || :

DATASETS=$@
for DATASET in ${DATASETS}; do
  docker rm -f ${DATASET} || :
  IMAGE=thegovlab/docker4data-${DATASET}
  docker pull ${IMAGE} &
done

echo 'Waiting for data to pull.'
wait

VOLUMES_FROM=''
for DATASET in ${DATASETS}; do IMAGE=thegovlab/docker4data-${DATASET}
  DATA_CONTAINER=$(docker run --name ${DATASET} -d -v /${DATASET} ${IMAGE} sh)
  VOLUMES_FROM="${VOLUMES_FROM} --volumes-from ${DATASET}"
done

echo "Running docker4data container to import data"
docker run -p 54321:5432 -d --name docker4data ${VOLUMES_FROM} thegovlab/docker4data


while : ; do
  docker exec docker4data gosu postgres psql -c '\q' > /dev/null 2>&1 && break || echo "Waiting for postgres to start up"
  sleep 0.5
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

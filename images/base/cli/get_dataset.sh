#!/bin/bash -e

DUMPS=http://data.docker4data.com.s3-website-us-east-1.amazonaws.com/sqldump

DATASETS=$@

for DATASET in ${DATASETS}; do
  mkdir -p /$DATASET/
  wget -q -O /$DATASET/dump $DUMPS/$DATASET &
done

echo 'Waiting for data to download.'
wait

while : ; do
  gosu postgres psql -c '\q' > /dev/null 2>&1 && break || echo "Waiting for postgres to start up"
  sleep 0.2
done

for DATASET in $DATASETS; do
  echo "Restoring $DATASET"
  /usr/bin/time -o /${DATASET}.time gosu postgres pg_restore -v -d postgres /$DATASET/dump > /${DATASET}.log 2>&1 &
done

echo "Waiting for dataset imports"
while : ; do
  sleep 2
  FINISHED=''
  for DATASET in $DATASETS; do
    TIME=$(cat /${DATASET}.time) || continue
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
  echo 'to drop in, enter

     PGPASSWORD=docker4data psql -h $(boot2docker ip || echo localhost) -p 54321 -U postgres postgres

  '
else
  echo "to drop in, enter

     docker exec -it docker4data gosu postgres psql

  "
fi

#
#docker exec -i docker4data /bin/bash

#docker rm -f docker4data

#!/bin/bash -e

DUMPS=http://data.docker4data.com.s3-website-us-east-1.amazonaws.com/sqldump

DATASETS=$@

# Update our local metadata
echo "Updating metadata"
pushd /docker4data >/dev/null && git pull origin master >/dev/null 2>&1 && popd >/dev/null

# Make sure datasets actually exist
for DATASET in ${DATASETS}; do
  if [ -e /docker4data/$DATASET ]; then
    DATASETS_TO_DOWNLOAD="$DATASETS_TO_DOWNLOAD $DATASET"
  else
    SIMILAR="$(/cli/find.sh $DATASET)"
    SIMILAR_CNT=$(echo "$SIMILAR" | wc -l)
    if [ $SIMILAR_CNT == "0" ]; then
      echo 'There is no dataset "'$DATASET'", and nothing similar, skipping'
    elif [ $SIMILAR_CNT == "1" ]; then
      echo 'Substituting '\"$SIMILAR\"' for '\"$DATASET\"''
      DATASETS_TO_DOWNLOAD="$DATASETS_TO_DOWNLOAD $SIMILAR"
    else
      echo 'There is no dataset "'$DATASET'", but '$SIMILAR_CNT' like it, skipping

Could you have meant:

'"$SIMILAR"
    fi
  fi
done

DATASETS=$DATASETS_TO_DOWNLOAD

# Downloading datasets
for DATASET in ${DATASETS}; do
  mkdir -p /$DATASET/
  wget -q -O /$DATASET/dump $DUMPS/$DATASET &
done

echo 'Waiting for data to download.'
wait

for DATASET in ${DATASETS}; do
  if [ -s /$DATASET/dump ]; then
    DATASETS_TO_RESTORE="$DATASETS_TO_RESTORE $DATASET"
  else
    echo 'Unable to get pg_dump for "'$DATASET'", skipping'
  fi
done
DATASETS=$DATASETS_TO_RESTORE

if [ -z "$DATASETS" ]; then
  echo "No valid datasets specified"
  exit
fi

while : ; do
  gosu postgres psql -c '\q' > /dev/null 2>&1 && break || echo "Waiting for postgres to start up"
  sleep 0.2
done

for DATASET in $DATASETS; do
  echo "Restoring $DATASET"
  SCHEMA=$(dirname $DATASET)
  gosu postgres psql -c "CREATE SCHEMA IF NOT EXISTS \"$SCHEMA\";"
  /usr/bin/time -o /${DATASET}.time gosu postgres pg_restore -v -d postgres /$DATASET/dump > /${DATASET}.log 2>&1 &
done

echo "Waiting for dataset imports"
while : ; do
  FINISHED=''
  for DATASET in $DATASETS; do
    TIME=$(cat /${DATASET}.time) || continue
    if [ "$TIME" ] ; then
      FINISHED="$FINISHED $DATASET"
    fi
  done
  if [ "${DATASETS}" == "${FINISHED}" ] ; then
    echo "Finished importing '${FINISHED}' datasets"
    break
  else
    #echo "Imported '${FINISHED}' datasets, waiting for more"
    echo -n '.'
  fi
  sleep 1
done

#if [ $(which psql) ]; then
#  echo 'to drop in, enter
#
#     PGPASSWORD=docker4data psql -h $(boot2docker ip || echo localhost) -p 54321 -U postgres postgres
#
#  '
#else
  echo "To drop in, enter

     d4d psql

  "
#fi

#
#docker exec -i docker4data /bin/bash

#docker rm -f docker4data

#!/bin/bash

source /cli/_colors.sh

DUMPS=http://data.docker4data.com.s3-website-us-east-1.amazonaws.com/sqldump

DATASETS=$@

# Update our local metadata
info "Updating metadata"
cd /docker4data && git pull origin master >/dev/null 2>&1 && cd /

# Make sure datasets actually exist
for DATASET in ${DATASETS}; do
  if [ -e /docker4data/$DATASET ]; then
    DATASETS_TO_DOWNLOAD="$DATASETS_TO_DOWNLOAD $DATASET"
  else
    SIMILAR="$(/cli/find.sh $DATASET)"
    SIMILAR_CNT=$(echo "$SIMILAR" | wc -l)
    if [ -z $SIMILAR ]; then
      warn 'There is no dataset "'$DATASET'", and nothing similar, skipping'
    elif [ $SIMILAR_CNT == "1" ]; then
      info 'Substituting '\"$SIMILAR\"' for '\"$DATASET\"''
      DATASETS_TO_DOWNLOAD="$DATASETS_TO_DOWNLOAD $SIMILAR"
    else
      warn 'There is no dataset "'$DATASET'", but '$SIMILAR_CNT' like it, skipping

Could you have meant:

'"$SIMILAR"
    fi
  fi
done

DATASETS=$DATASETS_TO_DOWNLOAD

while : ; do
  gosu postgres psql -c '\q' > /dev/null 2>&1 && break || info "Waiting for postgres to start up"
  sleep 0.2
done

NUM_DATASETS=$(echo "${DATASETS}" | tr -cd ' ' | wc -c)

success "Installing ${NUM_DATASETS} datasets"

# Downloading datasets
for DATASET in ${DATASETS}; do
  mkdir -p /$DATASET/
  SCHEMA=$(dirname $DATASET)
  gosu postgres psql -c "CREATE SCHEMA IF NOT EXISTS \"$SCHEMA\";" >/dev/null 2>&1
  gosu postgres psql -c "DROP TABLE IF EXISTS \"$SCHEMA\".\"$DATASET\";" >/dev/null 2>&1
  wget --progress=bar:force -O - $DUMPS/$DATASET 2>/$DATASET/wget.log | \
    gosu postgres pg_restore -d postgres > /$DATASET/out.log 2>/$DATASET/err.log &
done

# Progress view
for DATASET in ${DATASETS}; do
  echo ''
done
while : ; do
  #echo -e "\033[${NUM_DATASETS}A"
  echo -e "\033[$(($NUM_DATASETS + 1))A"
  for DATASET in ${DATASETS}; do
    echo -e "\033[K$(tail -n 3 $DATASET/wget.log | grep -m 1 '%') $DATASET"
  done

  if [ -z "$(jobs)" ]; then
    # one last update
    #echo -e "\033[$(($NUM_DATASETS + 2))A"
    for DATASET in ${DATASETS}; do
      echo -e "\033[K$(tail -n 4 $DATASET/wget.log | grep -m 1 '%') $DATASET"
    done
    break
  else
    jobs >/dev/null
    sleep 1
  fi
done

echo "

To drop in, enter

   d4d psql

"

#!/bin/bash

UNIQUE=0
SEPARATOR=','
TABLE_URL="${@: -1}"

#INFILE=/share/${TABLE}.csv

#while getopts "un:s:" opt; do
#  case $opt in
#    u) UNIQUE=1 ;;
#    n) NAME=$OPTARG ;;
#    s) SEPARATOR=$OPTARG ;;
#  esac
#done

UNIQUE=$(if [ -e /unique ]; then echo -u; fi)
NAME=$(cat /name)
SEPARATOR=$(cat /separator)

echo $UNIQUE
echo $SEPARATOR
echo $TABLE_URL
echo $NAME

if [ ! $NAME ]; then
  echo 'Name must be specified'
  exit 1
else
  echo 'name specified'
  echo $NAME
fi

#wget -q -O ${NAME}.csv ${TABLE_URL}

gosu postgres psql < /schema.sql

gosu postgres echo "
LOAD CSV FROM stdin
  INTO postgresql://postgres@localhost/postgres?$NAME
  WITH skip header = 1,
       fields terminated by '$SEPARATOR';
" | tee /scripts/pgloader.load

if [ $UNIQUE ]; then
  gosu postgres tail -n +2 $INFILE | sort | uniq | pgloader /scripts/pgloader.load
else
  gosu postgres tail -n +2 $INFILE | pgloader /scripts/pgloader.load
fi

gosu postgres psql < /index.sql

exit 0

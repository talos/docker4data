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

if [ -e /unique ]; then
  UNIQUE=1
fi
NAME=$(cat /name)
SEPARATOR=$(cat /separator)

wget -q -O /${NAME}.csv ${TABLE_URL}
INFILE=/${NAME}.csv
#INFILE=/csv/${NAME}.csv

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

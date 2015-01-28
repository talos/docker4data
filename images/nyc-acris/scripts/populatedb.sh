#!/bin/bash

#gosu postgres pg_ctl -D /data -w start

psql < /scripts/schema.sql

for table in master parties legals references
do
  echo "
LOAD CSV FROM stdin
    INTO postgresql://postgres@localhost/postgres?acris_${table}
    WITH skip header = 1,
         fields terminated by ',';
" | tee /scripts/pgloader.load
  sort /csv/acris_${table}.csv | uniq | pgloader /scripts/pgloader.load
done

psql < /scripts/index.sql

#rm -r /csv

#gosu postgres pg_ctl -D /data -w stop

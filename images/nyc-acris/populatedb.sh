#!/bin/bash

gosu postgres pg_ctl -D /data -w start

gosu postgres psql < schema.sql

for table in master parties legals references
do
  echo "
LOAD CSV FROM stdin
    INTO postgresql://postgres@localhost/postgres?${table}
    WITH skip header = 1,
         fields terminated by ',';
" | tee /pgloader.load
  gosu postgres sort /csv/${table}.csv | uniq | pgloader /pgloader.load
done

gosu postgres pg_ctl -D /data -w stop

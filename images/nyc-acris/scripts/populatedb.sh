#!/bin/bash

psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql
psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql
psql -c "CREATE EXTENSION postgis;"

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

echo "
LOAD CSV FROM stdin
    INTO postgresql://postgres@localhost/postgres?pluto
    WITH skip header = 1,
         fields terminated by '\t';
" | tee /scripts/pgloader.load
cat /csv/pluto.csv | pgloader /scripts/pgloader.load

#rm -r /csv

#gosu postgres pg_ctl -D /data -w stop

#!/bin/bash

FULLNAME=$1
OUT=$2

TABLENAME=$(basename $FULLNAME)
SCHEMANAME=$(dirname $FULLNAME)

gosu postgres pg_dump -F c -Z 9 --schema=\"${SCHEMANAME}\" \
    -t \"${SCHEMANAME}\".\"${TABLENAME}\" -f ${OUT} postgres

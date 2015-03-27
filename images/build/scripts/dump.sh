#!/bin/bash

NAME=$1
OUT=$2

gosu postgres pg_dump -F c -Z 9 -t ${NAME} -f ${OUT} postgres

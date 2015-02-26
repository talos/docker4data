#!/bin/bash

NAME=$1

gosu postgres pg_dump -F c -Z 9 -t ${NAME} -f /share/${NAME} postgres

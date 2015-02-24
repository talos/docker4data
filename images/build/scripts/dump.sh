#!/bin/bash

NAME=$(cat /name)

gosu postgres pg_dump -F c -Z 9 -t ${NAME} -f /share/${NAME} postgres

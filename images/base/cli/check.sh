#!/bin/bash -e

DUMPS=http://data.docker4data.com.s3-website-us-east-1.amazonaws.com/sqldump
DATASET=$1

wget -S --spider -O /dev/null $DUMPS/$DATASET

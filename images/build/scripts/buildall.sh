#!/bin/bash

# Build every dataset we've got!

#cd /docker4data/data

for path in $(ls -d /docker4data/data/$1/*) ; do
  dataset=$(echo $path | cut -d / -f 3-)
  echo $dataset
  /scripts/build.sh $dataset
done

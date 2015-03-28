#!/bin/bash

# Build every dataset we've got!

for path in "$@" ; do
  dataset=$(basename $path)
  echo $dataset
  /scripts/build.sh $dataset
done

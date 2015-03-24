#!/bin/bash -e

# Build every dataset we've got!

source .env/bin/activate

for path in "$@" ; do
  dataset=$(basename $path)
  echo $dataset
  ./build.sh $dataset
done

deactivate

#!/bin/bash

# Build every data.json in the specified path, assuming an initial ../../ will
# be eliminated.

echo "$@"
for dir in "$@" ; do
  for name in $(find $dir -name data.json); do
    name=$(dirname $(echo $name | cut -d / -f 4-))
    logdir=logs/$name
    echo $name
    ./run.sh
    mkdir -p $logdir
    echo $(date) >> logs/$name.log
    ./exec.sh scripts/process.sh $name | tee -a $logdir.log
  done
done

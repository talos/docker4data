#!/bin/bash

# Build every data.json in the specified path, assuming an initial ../../ will
# be eliminated.

echo "$@"
for dir in "$@" ; do
  for name in $(find $dir -name data.json); do
    name=$(dirname $(echo $name | cut -d / -f 4-))
    logname=logs/$name.log
    echo $name
    ./run.sh
    mkdir -p $(dirname $logname)
    echo $(date) >> $logname
    ./exec.sh scripts/process.sh $name > >(tee -a $logname) 2> >(tee -a $logname >&2)
  done
done

#!/bin/bash

ls *.csv | \
  tail -n 1 | \
  xargs head -n 1 | \
  sed -E 's/ +/ /g' \
  > ${DATASET}.tmp

ls *.csv | \
  xargs tail -q -n +2 | \
  sed 's/[^[:print:]]//g' | \
  sed -E 's/ +/ /g' \
  >> ${DATASET}.tmp

mv ${DATASET}.tmp ${DATASET}.csv

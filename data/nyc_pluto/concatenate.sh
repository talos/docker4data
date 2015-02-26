#!/bin/bash

gunzip ${DATASET}

ls *.csv | \
  tail -n 1 | \
  xargs head -n 1 | \
  sed -E 's/ +/ /g' \
  > ${DATASET}.concatenated

ls *.csv | \
  xargs tail -q -n +2 | \
  sed 's/[^[:print:]]//g' | \
  sed -E 's/ +/ /g' \
  >> ${DATASET}.concatenated

mv ${DATASET}.concatenated ${DATASET}

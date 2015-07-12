#!/bin/bash -e

if [[ -n "$@" ]]; then
  docker exec docker4data $@
else
  docker exec -it docker4data /bin/bash
fi

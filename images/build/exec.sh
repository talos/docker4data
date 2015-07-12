#!/bin/bash -e

if [[ -n "$@" ]]; then
  docker exec docker4data-build $@
else
  docker exec -it docker4data-build /bin/bash
fi

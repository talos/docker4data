#!/bin/bash -e

CHOSEN_FRONTEND=$1
FRONTENDS=$(docker search docker4data-vis | tail -n +2 | grep -Po '^[^ ]+')

for frontend in ${FRONTENDS}; do
  NAME=$(echo $FRONTENDS | sed -r 's:.*docker4data-vis-(.*):\1:g')

  if [ $NAME == $1 ]; then
    echo "Pulling frontend $frontend"
    docker pull $frontend
    docker rm -f docker4data-visual || :
    docker run --name docker4data-visual --link docker4data:docker4data -p 8000:8000 -d $frontend
    exit 0
  fi
done

echo "No frontend '$1'"
exit 1

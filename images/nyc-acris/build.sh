#!/bin/bash

# TODO just inherit straight from the base...
docker build -t thegovlab/docker4data-acris-base:latest .

docker rm acris-build || :
docker run -d -v $(pwd)/../csv:/csv --name acris-build thegovlab/docker4data-acris-base:latest

#docker start acris

echo "Importing acris_master"
time docker exec acris-build /bin/bash /scripts/load.sh -u -s ',' acris_master
echo "Committing acris_master"
time docker commit -m 'adding master' acris-build

echo "Importing acris_parties"
time docker exec acris-build /bin/bash /scripts/load.sh -s ',' acris_parties
echo "Committing acris_parties"
time docker commit -m 'adding parties' acris-build

echo "Importing acris_legals"
time docker exec acris-build /bin/bash /scripts/load.sh -s ',' acris_legals
echo "Committing acris_legals"
time docker commit -m 'adding legals' acris-build

echo "Importing acris_references"
time docker exec acris-build /bin/bash /scripts/load.sh -s ',' acris_references
echo "Committing acris_references"
time docker commit -m 'adding references' acris-build

echo "Importing pluto"
time docker exec acris-build /bin/bash /scripts/load.sh -s '\t' pluto
echo "Committing pluto"
time docker commit -m 'adding pluto' acris-build

echo "Adding indexes"
time docker exec acris-build gosu postgres psql -f /scripts/index.sql
echo "Committing indexes"
time docker commit -m 'adding indexes' acris-build

docker stop acris-build

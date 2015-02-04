#!/bin/bash

docker rm acris || :
docker run -d -v $(pwd)/../csv:/csv -p 8080:8080 --name acris thegovlab/docker4data-acris-base

#docker start acris

echo "Importing acris_master"
time docker exec acris /bin/bash /scripts/load.sh -u -s ',' acris_master
echo "Committing acris_master"
time docker commit -m 'adding master' acris

echo "Importing acris_parties"
time docker exec acris /bin/bash /scripts/load.sh -s ',' acris_parties
echo "Committing acris_parties"
time docker commit -m 'adding parties' acris

echo "Importing acris_legals"
time docker exec acris /bin/bash /scripts/load.sh -s ',' acris_legals
echo "Committing acris_legals"
time docker commit -m 'adding legals' acris

echo "Importing acris_references"
time docker exec acris /bin/bash /scripts/load.sh -s ',' acris_references
echo "Committing acris_references"
time docker commit -m 'adding references' acris

echo "Importing pluto"
time docker exec acris /bin/bash /scripts/load.sh -s '\t' pluto
echo "Committing pluto"
time docker commit -m 'adding pluto' acris

echo "Adding indexes"
time docker exec acris gosu postgres psql -f /scripts/index.sql
echo "Committing indexes"
time docker commit -m 'adding indexes' acris

docker stop acris

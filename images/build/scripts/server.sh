#!/bin/bash

./build.sh 'https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_acris_legals/data.json' > legals.log 2>&1 &
./build.sh 'https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_acris_master/data.json' > master.log 2>&1 &
./build.sh 'https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_acris_parties/data.json' > parties.log 2>&1 &
./build.sh 'https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_pluto/data.json' > nyc_pluto.log 2>&1 &
./build.sh 'https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_multiple_dwelling_registrations/data.json' > multiple_dwelling_registrations.log 2>&1 &
./build.sh 'https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_pluto/data.json' > pluto.log 2>&1 &

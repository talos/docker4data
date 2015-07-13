#!/bin/bash -e

cd /docker4data && git grep --color -i $@ -- data/*/data.json

#pushd /docker4data/data/*/data.json && git grep -i $@ && popd

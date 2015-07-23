#!/bin/bash

source /cli/_colors.sh

# Update our local metadata
info "Updating metadata"
cd /docker4data
git pull origin master
cd /

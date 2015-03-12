#!/bin/bash -e

docker search d4d | cut -d ' ' -f 1-2 | cut -c 15-50 | tail -n +2

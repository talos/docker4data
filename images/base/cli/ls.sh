#!/bin/bash -e

find /docker4data/data/ -iname data.json | head | sed s:/data.json::

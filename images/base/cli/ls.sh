#!/bin/bash -e

find /docker4data/data/ -iname data.json | head | sed s:/docker4data/data/:: | sed s:/data.json::

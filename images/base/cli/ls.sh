#!/bin/bash -e

find /docker4data/data/ -iname data.json | sed s:/docker4data/data/:: | sed s:/data.json::

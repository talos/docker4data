#!/bin/bash

# Return list of possible datasets based off of user input

DATASET=$1

/cli/ls.sh | grep $DATASET

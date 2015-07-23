#!/bin/bash

echo '

Basic docker4data commands:

[available]

  d4d find <TERM>: Find a dataset by name
  d4d help: Show this help menu
  d4d info <DATASET_NAME>: Info on the named dataset
  d4d install <DATASET_NAME>: Install the named dataset
  d4d ls: List all available datasets
  d4d psql: Launch into postgres
  d4d shell: Drop into a bash prompt inside the container
  d4d update: Update metadata from git

[todo]

  d4d search <TERMS>: Search for a dataset by specified terms in metadata

'

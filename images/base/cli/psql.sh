#!/bin/bash

# Make sure we have a directory for psql to save history
mkdir -p /home/postgres
chown -R postgres:postgres /home/postgres

# Extract all extant schemas and add them to search path.
SCHEMAS=$(gosu postgres psql --no-align --field-separator , -c '\dn')

SCHEMAS=$(echo "$SCHEMAS" | tail -n +3 | head -n -1 | cut -d , -f 1)
SCHEMAS=$(echo -n "$SCHEMAS" | tr '\n' , | sed 's:,:",":g')

CUR_SEARCH_PATH=$(gosu postgres psql --no-align --field-separator , -c 'SHOW search_path;' | tail -n +2 | head -n -1)

export PGOPTIONS="-c search_path=$CUR_SEARCH_PATH,\"$SCHEMAS\""

gosu postgres psql

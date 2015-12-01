#!/bin/bash
set -e

export PGDATA=/var/lib/postgresql/data
export POSTGRES_USER=postgres

mkdir "$PGDATA"
chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then echo 'init db'
  gosu postgres initdb

  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf
  { echo; echo 'host all all 0.0.0.0/0 md5'; } >> "$PGDATA"/pg_hba.conf

  #pgtune -T Web -i "$PGDATA"/postgresql.conf > "$PGDATA"/local.conf
  #{ echo; echo "include = 'local.conf'"; } >> "$PGDATA"/postgresql.conf

  gosu postgres pg_ctl -w start 

  if [ -n "$POSTGRES_DB" ]; then 
    gosu postgres createdb -O $POSTGRES_USER $POSTGRES_DB
  fi
  gosu postgres psql -c "ALTER USER $POSTGRES_USER WITH PASSWORD '$PASSWORD';"

  gosu postgres pg_ctl stop 
fi

if [ -d /docker-entrypoint-initdb.d ]; then
  for f in /docker-entrypoint-initdb.d/*.sh; do
    [ -f "$f" ] && . "$f"
  done
fi

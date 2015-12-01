#/usr/local/openresty/nginx/sbin/nginx -p / -c /conf/nginx.conf
#gosu postgres pg_ctl -D /data -w start


export PGDATA=/var/lib/postgresql/data

mkdir -p /data

chown -R postgres /data
gosu postgres pg_ctl -w start 
gosu postgres createdb tmp
gosu postgres psql -d tmp -c "CREATE TABLESPACE docker4data LOCATION '/data';"
gosu postgres psql -d tmp -c "ALTER DATABASE postgres SET default_tablespace = docker4data;"
gosu postgres pg_ctl -w stop 

gosu postgres postgres -D /var/lib/postgresql/data

#bash
#exec "$@"

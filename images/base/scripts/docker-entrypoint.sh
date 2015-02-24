#/usr/local/openresty/nginx/sbin/nginx -p / -c /conf/nginx.conf
#gosu postgres pg_ctl -D /data -w start
gosu postgres postgres -D /data

#bash
#exec "$@"

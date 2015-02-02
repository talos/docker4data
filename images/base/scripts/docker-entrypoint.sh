gosu postgres pg_ctl -D /data -w start
/usr/local/openresty/nginx/sbin/nginx -p / -c /scripts/nginx.conf

su postgres

bash
#exec "$@"

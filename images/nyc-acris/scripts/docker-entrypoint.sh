gosu postgres pg_ctl -D /data -w start
/usr/local/openresty/nginx/sbin/nginx -p / -c /scripts/nginx.conf

# Keepalive, otherwise it seems to be impossible to background this without
# explicitly running -d
while : ; do
  sleep 1
done

#!/bin/bash

touch /opt/splunk/etc/.ui_login

# enable insecure login
sed -i '/^enable_insecure_login/c \
enable_insecure_login = True' /opt/splunk/etc/system/default/web.conf

#cat app.conf
echo '[install]
is_configured = 1' > /opt/splunk/etc/apps/dbx/local/app.conf

#cat java.conf
echo '[java]
home = /usr/lib/jvm/java-7-openjdk-amd64' > /opt/splunk/etc/apps/dbx/local/java.conf

#cat inputs.conf
echo '[script://./bin/jbridge_server.py]
disabled = 0

[batch://$SPLUNK_HOME/var/spool/dbmon/*.dbmonevt]
crcSalt = <SOURCE>
disabled = 0
move_policy = sinkhole
sourcetype = dbmon:spool' > /opt/splunk/etc/apps/dbx/local/inputs.conf

#cat local.meta
echo '[database/docker4data]
version = 6.2.1
modtime = 1425421294.054959000' > /opt/splunk/etc/apps/dbx/metadata/local.meta

echo "host = $DOCKER4DATA_PORT_5432_TCP_ADDR" >> /opt/splunk/etc/apps/dbx/local/database.conf
echo "port = $DOCKER4DATA_PORT_5432_TCP_PORT" >> /opt/splunk/etc/apps/dbx/local/database.conf
echo "password = $DOCKER4DATA_ENV_PASSWORD" >> /opt/splunk/etc/apps/dbx/local/database.conf

#!/bin/bash

echo "host = $DOCKER4DATA_PORT_5432_TCP_ADDR" >> /opt/splunk/etc/apps/dbx/local/database.conf
echo "port = $DOCKER4DATA_PORT_5432_TCP_PORT" >> /opt/splunk/etc/apps/dbx/local/database.conf
echo "password = $DOCKER4DATA_ENV_PASSWORD" >> /opt/splunk/etc/apps/dbx/local/database.conf

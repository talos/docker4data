#!/bin/bash

apt-get update --fix-missing
apt-get install -y freetds-dev wget openssl ca-certificates apt-transport-https


echo "===> add user and group to make sure their IDs get assigned consistently" && \
  groupadd -r postgres && useradd -r -g postgres postgres && \
  \
  \
  echo "===> grab gosu for easy step-down from root" && \
  wget -O /usr/local/bin/gosu \
      https://github.com/tianon/gosu/releases/download/1.1/gosu  && \
  chmod +x /usr/local/bin/gosu && \
  \
  \
  echo "make en_US.UTF-8 locale so postgres will be utf-8 enabled by default" && \
  apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

echo "===> install postgres" && \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" | tee \
    /etc/apt/sources.list.d/wheezy-pgdg.list  && \
  wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    apt-key add - && \
  apt-get update && \
  apt-get install -y postgresql-common && \
  sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf && \
  apt-get install -y postgresql-9.3-postgis-2.1 postgresql-contrib pgtune && \
  \
  \
  echo "===> clean up" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "===> install pgloader" && \
  echo "deb http://ftp.debian.org/debian sid main" | tee \
    /etc/apt/sources.list.d/sid.list && \
  apt-get update && \
  apt-get install -y libc6 && \
  \
  \
  echo "===> downloading pgloader" && \
  wget -q "http://pgloader.io/files/pgloader_3.2.0+dfsg-1_amd64.deb" && \
  dpkg -i "pgloader_3.2.0+dfsg-1_amd64.deb" && \
  \
  \
  echo "===> clean up" && \
  apt-get clean && \
  rm -f /pgloader_3.2.0+dfsg-1_amd64.deb

echo "===> install openresty" && \
  apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev \
                     perl make build-essential postgresql-server-dev-9.3 && \
  wget -q http://openresty.org/download/ngx_openresty-1.7.7.1.tar.gz && \
  tar xzvf ngx_openresty-1.7.7.1.tar.gz && \
  cd ngx_openresty-1.7.7.1/ && \
  ./configure --with-http_postgres_module --with-pcre-jit && \
  make && \
  make install && \
  echo "===> clean up" && \
  rm -rf ngx_openresty*
  #apt-get remove -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev \
  #    perl make build-essential && \
  #apt-get clean

mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

echo "===> install postgis" && \
    gosu postgres pg_ctl -D /data -w start && \
    gosu postgres psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql && \
    gosu postgres psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql && \
    gosu postgres psql < /scripts/schema.sql && \
    gosu postgres pg_ctl -D /data stop

#apt-get remove -y freetds-dev wget openssl ca-certificates \
#  apt-transport-https

/scripts/createdb.sh

mkdir /csv
mkdir /logs

localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

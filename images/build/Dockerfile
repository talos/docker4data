#
# Docker4Data build image -- use this as a build tool
#
# https://github.com/talos/docker4data
#

FROM debian:wheezy
MAINTAINER John Krauss <irving.krauss@gmail.com>

ENV LANG en_US.UTF8
ENV LC_ALL en_US.UTF8
ENV LANGUAGE en_US.UTF8
ENV PATH /usr/lib/postgresql/9.3/bin:$PATH

RUN apt-get update --fix-missing
RUN apt-get install -y freetds-dev wget openssl ca-certificates apt-transport-https

RUN echo "===> add user and group to make sure their IDs get assigned consistently" && \
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

RUN echo "===> install postgres" && \
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

RUN echo "===> install pgloader" && \
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

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

COPY scripts /scripts
RUN /scripts/createdb.sh

RUN echo "===> install postgis" && \
    gosu postgres pg_ctl -D /data -w start && \
    gosu postgres psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql && \
    gosu postgres psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql && \
    gosu postgres pg_ctl -D /data stop


RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENTRYPOINT ["/bin/bash", "-c"]
CMD /scripts/postgres.sh

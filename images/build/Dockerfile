#
# Docker4Data build image -- use this as a build tool
# # https://github.com/talos/docker4data #

FROM debian:wheezy
MAINTAINER John Krauss <irving.krauss@gmail.com>

ENV LANG en_US.UTF8
ENV LC_ALL en_US.UTF8
ENV LANGUAGE en_US.UTF8
ENV PATH /usr/lib/postgresql/9.4/bin:$PATH

RUN echo "deb http://ftp.debian.org/debian sid main" | tee \
    /etc/apt/sources.list.d/debian-sid.list
RUN apt-get update --fix-missing
RUN apt-get install -y freetds-dev wget openssl ca-certificates apt-transport-https python-pip gdal-bin curl make bzip2 subversion libc6

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
  apt-get install -y postgresql-9.4-postgis-2.1 postgresql-contrib pgtune && \
  \
  \
  echo "===> clean up" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD install.lisp /tmp/install.lisp
RUN echo "===> download CCL" && \
  mkdir -p /tmp && cd /tmp && \
  svn co http://svn.clozure.com/publicsvn/openmcl/release/1.10/linuxx86/ccl && \
  wget -q http://beta.quicklisp.org/quicklisp.lisp

RUN echo "===> install CCL" && \
  /tmp/ccl/lx86cl64 -l /tmp/install.lisp && \
  ln -s /tmp/ccl/lx86cl64 /usr/bin/ccl && \
  cd /

RUN echo "===> install pgloader" && \
  git clone https://github.com/dimitri/pgloader.git && \
  cd /pgloader && \
  git checkout 388dc31cb73bd196043f06fd02b0650fab81158b && \
  make CL=ccl pgloader && \
  ln -s /pgloader/build/bin/pgloader /usr/bin/pgloader

#RUN echo "===> install pgloader" && \
#  echo "deb http://ftp.debian.org/debian sid main" | tee \
#    /etc/apt/sources.list.d/sid.list && \
#  apt-get update && \
#  apt-get install -y libc6 && \
#  \
#  \
#  echo "===> downloading pgloader" && \
#  wget -q "http://pgloader.io/files/pgloader_3.2.0+dfsg-1_amd64.deb" && \
#  dpkg -i "pgloader_3.2.0+dfsg-1_amd64.deb" && \
#  \
#  \
#  echo "===> clean up" && \
#  apt-get clean && \
#  rm -f /pgloader_3.2.0+dfsg-1_amd64.deb

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

COPY scripts /scripts

RUN pip install -r /scripts/requirements.txt
RUN /scripts/createdb.sh

RUN echo "===> install postgis" && \
    gosu postgres pg_ctl -D /data -w start && \
    gosu postgres psql < /usr/share/postgresql/9.4/contrib/postgis-2.1/postgis.sql && \
    gosu postgres psql < /usr/share/postgresql/9.4/contrib/postgis-2.1/spatial_ref_sys.sql && \
    gosu postgres pg_ctl -D /data stop

RUN apt-get update --fix-missing
RUN apt-get install -yqq time unzip git-core
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN git clone https://github.com/talos/docker4data.git

VOLUME /root/.ssh
VOLUME /root/.aws

ENTRYPOINT ["/bin/bash", "-c"]
CMD /scripts/postgres.sh

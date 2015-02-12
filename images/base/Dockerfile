#
# Experimental NYC ACRIS datafile for docker4data
#
# https://github.com/talos/docker4data
#

FROM debian:wheezy
MAINTAINER John Krauss <irving.krauss@gmail.com>

ENV LANG en_US.UTF8
ENV LC_ALL en_US.UTF8
ENV LANGUAGE en_US.UTF8
ENV PATH /usr/lib/postgresql/9.3/bin:$PATH

COPY scripts /scripts
COPY conf /conf
COPY site /site

RUN scripts/prereqs.sh

ENTRYPOINT "/scripts/docker-entrypoint.sh"

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

RUN scripts/prereqs.sh
#VOLUME ["/csv"]

#RUN /scripts/createdb.sh
#
#RUN chown -R postgres /scripts

#ADD data/* /csv/

#RUN /populatedb.sh

ENTRYPOINT "/scripts/docker-entrypoint.sh"

#ADD data/legals.csv.gz /raw/
#ADD data/master.csv.gz /raw/
#ADD data/parties.csv.gz /raw/
#ADD data/references.csv.gz /raw/
#ADD data/remarks.csv.gz /raw/

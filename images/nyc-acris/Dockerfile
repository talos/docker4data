#
# Experimental NYC ACRIS datafile for docker4data
#
# https://github.com/talos/docker4data
#

FROM thegovlab/docker4data-base:latest
MAINTAINER John Krauss <irving.krauss@gmail.com>

RUN chown -R postgres /scripts/
RUN chmod a+x /scripts/*

USER postgres
ENV PATH /usr/lib/postgresql/9.3/bin:$PATH

#COPY csv/ /csv
COPY scripts/ /scripts

USER root

#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -u -s ',' acris_master #RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s ',' acris_parties
#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s ',' acris_legals
#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s ',' acris_references
#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s '\t' pluto
#RUN pg_ctl -D /data -w start && psql < /scripts/index.sql

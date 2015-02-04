#
# Experimental NYC ACRIS datafile for docker4data
#
# https://github.com/talos/docker4data
#

FROM thegovlab/docker4data-base
MAINTAINER John Krauss <irving.krauss@gmail.com>

RUN chown -R postgres /scripts/
RUN chmod a+x /scripts/*

USER postgres
ENV PATH /usr/lib/postgresql/9.3/bin:$PATH

#COPY csv/ /csv
COPY scripts/ /scripts

#RUN gosu postgres pg_ctl -D /data -w start
RUN pg_ctl -D /data -w start && \
    psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql && \
    psql < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql && \
    psql < /scripts/schema.sql && \
    pg_ctl -D /data stop

USER root

#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -u -s ',' acris_master #RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s ',' acris_parties
#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s ',' acris_legals
#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s ',' acris_references
#RUN pg_ctl -D /data -w start && /bin/bash /scripts/load.sh -s '\t' pluto
#RUN pg_ctl -D /data -w start && psql < /scripts/index.sql

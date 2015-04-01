FROM elasticsearch:1.4

RUN apt-get update --fix-missing
RUN apt-get install -y openssl ca-certificates apt-transport-https python-pip git-core

COPY scripts /scripts
RUN /scripts/index.sh

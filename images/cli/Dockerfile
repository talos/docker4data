#
# Docker4Data cli image -- this is used to download Docker4Data imags locally
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
RUN apt-get install -y openssl ca-certificates apt-transport-https python-pip

COPY requirements.txt /
COPY bin /bin

RUN pip install -r /requirements.txt

#
# Experimental Dockerfile for Splunk
#

FROM debian:wheezy
MAINTAINER John Krauss <irving.krauss@gmail.com>

RUN apt-get update
RUN apt-get install -yqq wget procps

# install OpenJDK
RUN apt-get install -yqq openjdk-7-jre
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Download & install splunk
#RUN wget -q -O /tmp/splunk-6.2.1-245427-Linux-x86_64.tgz 'http://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=Linux&version=6.2.1&product=splunk&wget=true'
COPY splunk-6.2.1-245427-Linux-x86_64.tgz /tmp/
RUN tar xf /tmp/splunk-6.2.1-245427-Linux-x86_64.tgz -C /opt

# Configure splunk to be happy with small amounts of space (we're not loading
# anything in)
RUN sed -i '/^minFreeSpace/c \
minFreeSpace = 1' /opt/splunk/etc/system/default/server.conf

# Download & install DBConnect
#RUN wget -q -O /tmp/dbconnect.gz 'https://d38o4gzaohghws.cloudfront.net/media/private/b6fd9908-809d-11e4-918f-0ae2eca10a2b.tgz?response-content-disposition=attachment%3Bfilename%3D%22splunk-db-connect_116.tgz%22&Expires=1423516112&Signature=TndqqhfheoiOyJOuN-L9O2D9ntb0hJjaY2v06TErEHimtjUMLmNQd5T8plVXrVMoZXvhRKAlWTo5Ttk0x-DxNQ4gGoIPHI5gX~3EuFRFPJCvZxqffFiDSBOcmVBCbiOk9GDt4JOlyBQn49RTU2q2n6r3yThLNfQZuksKHBuScPHA-43fA505bOMwxJiyAD0qyHp0Q7i3SjPjGnw768dhKFS~GEDYkJARojsex1yt7zXdZOOoqAQaBc1ag-j2yVzIIszrYJS~7hVIpdG5qF842naL32y2PHq5VNTBapIHrvgJXz9qZwKa~zRC5~KFEaE9y0-47SmbXHTARdLIJOMX3g__&Key-Pair-Id=APKAISM7Q7KZPNKOIT7Aa'
COPY dbconnect.tgz /tmp/
RUN tar xf /tmp/dbconnect.tgz -C /opt/splunk/etc/apps

# TODO configure DBConnect (JAVA_HOME & postgres DB)
RUN mkdir /opt/splunk/etc/apps/dbx/local
COPY database.conf /opt/splunk/etc/apps/dbx/local/

# password = enc:0EjHPN2VR/lnKQELPl5Igg==

RUN rm -rf /tmp/*

VOLUME /opt/splunk/var

EXPOSE 8000
EXPOSE 8089
EXPOSE 9997

COPY configure.sh /
COPY run.sh /

ENTRYPOINT /configure.sh && echo y | /opt/splunk/bin/splunk start && /bin/bash /run.sh

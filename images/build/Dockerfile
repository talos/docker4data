#
# Docker4Data Build image
#
# https://github.com/talos/docker4data
#

FROM thegovlab/docker4data
MAINTAINER John Krauss <irving.krauss@gmail.com>

ENV PATH /usr/lib/postgresql/9.4/bin:$PATH

RUN echo "deb http://ftp.debian.org/debian sid main" | tee \
    /etc/apt/sources.list.d/debian-sid.list
RUN apt-get update --fix-missing
RUN apt-get install -y python-pip gdal-bin curl make bzip2 subversion libc6 \
  time unzip

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

COPY scripts /scripts

RUN pip install -r /scripts/requirements.txt

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

VOLUME /root/.ssh
VOLUME /root/.aws

ENTRYPOINT ["/bin/bash", "-c"]
CMD /scripts/postgres.sh

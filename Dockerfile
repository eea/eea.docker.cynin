FROM eeacms/centos:7

# CYNIN installation
ENV CYNIN_VERSION 3.2.2
ENV CYNIN_PATH /var/local
ENV CYNIN_BUILDOUT https://svn.eionet.europa.eu/repositories/Zope/trunk/community.eea.europa.eu/trunk 
ENV CYNIN_NAME community.eea.europa.eu
ENV INSTANCEDIR $CYNIN_PATH/$CYNIN_NAME

# needed for proper PIL compiling
RUN yum install -y freetype-devel && \
    ln -s /usr/lib64/libfreetype.so.6 /usr/lib/libfreetype.so && \
    ln -s /usr/lib64/libz.so /usr/lib/ && \
    ln -s /usr/lib64/libjpeg.so /usr/lib/

RUN useradd cynin -d $INSTANCEDIR -u 1000

USER cynin

WORKDIR $INSTANCEDIR

RUN svn co $CYNIN_BUILDOUT . && ./install.sh

RUN bin/buildout -c base.cfg

USER root

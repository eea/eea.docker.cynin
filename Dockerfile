FROM eeacms/centos:7
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

ENV CYNIN_PATH /var/local
ENV CYNIN_BUILDOUT https://svn.eionet.europa.eu/repositories/Zope/trunk/community.eea.europa.eu/trunk
ENV CYNIN_NAME community.eea.europa.eu
ENV INSTANCEDIR $CYNIN_PATH/$CYNIN_NAME

# needed for proper PIL compiling
RUN ln -s /usr/lib64/libfreetype.so.6 /usr/lib/libfreetype.so && \
    ln -s /usr/lib64/libz.so /usr/lib/ && \
    ln -s /usr/lib64/libjpeg.so /usr/lib/

WORKDIR $INSTANCEDIR
RUN groupadd -g 500 cynin && \
    useradd cynin -d $INSTANCEDIR -u 500 -g cynin && \
    chown -R cynin:cynin $INSTANCEDIR

USER cynin
RUN svn co $CYNIN_BUILDOUT . && ./install.sh
RUN bin/buildout -c deploy.cfg
FROM debian:stretch-slim
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

ENV CYNIN_PATH /var/local
ENV CYNIN_BUILDOUT https://svn.eionet.europa.eu/repositories/Zope/trunk/community.eea.europa.eu/tags/2.0
ENV CYNIN_NAME community.eea.europa.eu
ENV INSTANCEDIR $CYNIN_PATH/$CYNIN_NAME



RUN groupadd -g 500 cynin && \
    mkdir -p $INSTANCEDIR && \
    useradd cynin -d $INSTANCEDIR -u 500 -g cynin && \
    chown -R cynin:cynin $INSTANCEDIR


COPY install.sh /tmp/


RUN  apt-get update && \
     apt-get -y  install ca-certificates git wget gcc build-essential libxml2-dev libssl-dev  libxmlsec1-dev zlib1g-dev subversion cron gosu nano && \
     apt-get -y install libsasl2-dev libldap2-dev libssl1.0-dev && \
    mkdir /opt/python-2.4 && \
    cd /tmp && \
    wget https://www.python.org/ftp/python/2.4.6/Python-2.4.6.tgz && \
    tar zxf Python-2.4.6.tgz && \
    cd Python-2.4.6 && \
    find / -name *ssl && \ 
    grep -i ssl Modules/Setup.dist  && \
    sed -i '/_ssl/s/^#//g' Modules/Setup.dist && \
    sed -i '/DUSE_SSL/s/^#//g' Modules/Setup.dist && \
    sed -i '/lssl/s/^#//g' Modules/Setup.dist && \
    grep -i ssl Modules/Setup.dist  && \
    ./configure --with-zlib=/usr/include --prefix=/opt/python-2.4 --enable-ipv6 && \
    sed -i "s/^#zlib/zlib/g" Modules/Setup && \
    make && \
    make install && \
    ls /opt/python-2.4/bin && \
    ln -s  /opt/python-2.4/bin/python2.4 //usr/local/bin/python2.4 && \
    cd $INSTANCEDIR && \
    svn co $CYNIN_BUILDOUT . && \
    mv /tmp/install.sh . && \
    ./install.sh && \
    ./bin/buildout -c deploy.cfg && \
    touch var/log/event.log && \
    chown -R cynin:cynin $INSTANCEDIR && \
    apt-get remove -y --purge git subversion gcc build-essential && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* 

# needed for proper PIL compiling
#RUN ln -s /usr/lib64/libfreetype.so.6 /usr/lib/libfreetype.so && \
#    ln -s /usr/lib64/libz.so /usr/lib/ && \
#    ln -s /usr/lib64/libjpeg.so /usr/lib/ && \
#    curl https://bootstrap.pypa.io/get-pip.py | python3.4 


WORKDIR $INSTANCEDIR


USER root
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]

FROM ubuntu:16.04
MAINTAINER zoomcook 'ops@winshare-edu.com'
LABEL role='fastdfs' version='0.0.1' tags='fastdfs' description='fastdfs server based on docker'
ARG FASTDFSDIR="/data/fdfs"
ENV TIMEZONE="Asia/Shanghai" \
    GROUP="group1"
#install software
RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list && apt-get update && \
 apt-get install -y gcc autoconf automake make unzip wget netcat\
 && cd /srv/ \
 && wget https://github.com/happyfish100/fastdfs/archive/master.zip -O fastdfs.zip \
 && wget https://github.com/happyfish100/libfastcommon/archive/master.zip -O libfastcommon.zip \
 && wget https://github.com/happyfish100/fastdfs-nginx-module/archive/master.zip -O fast-nginx-module.zip \
 && wget http://nginx.org/download/nginx-1.8.0.tar.gz \
 && unzip libfastcommon.zip && cd /srv/libfastcommon-master/ && ./make.sh && ./make.sh install && cd .. \
 && echo "/usr/lib64/" > /etc/ld.so.conf.d/libfastcommon.conf && ldconfig \
 && unzip fastdfs.zip && cd /srv/fastdfs-master/ && ./make.sh && ./make.sh install && cd .. \
 && useradd -d $FASTDFSDIR -s /sbin/nologin -r fastdfs \
 && unzip fast-nginx-module.zip && tar xf nginx-1.8.0.tar.gz \
 && apt-get -y install libssl-dev zlib1g-dev libgoogle-perftools-dev libpcre3-dev libpcre++-dev libssl-dev libgeoip-dev && cd nginx-1.8.0 \
 && ./configure  --prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--without-http_geo_module \
--without-http_fastcgi_module \
--without-http_uwsgi_module \
--without-http_scgi_module  \
--without-http_memcached_module \
--without-http_limit_conn_module \
--without-http_limit_req_module \
--with-file-aio --with-ipv6 --with-http_spdy_module \
--with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' \
--add-module=/srv/fastdfs-nginx-module-master/src/ \
 && make && make install \
 && mkdir -p /var/cache/nginx/{scgi_temp,uwsgi_temp,fastcgi_temp,proxy_temp,client_temp} \
 && mkdir -p /var/log/fastdfs && chown fastdfs:fastdfs -R /var/log/fastdfs \
 && cd / && rm -rf /srv/*
#copy init files
ADD opt /opt/
ADD fastdfs /etc/fdfs/
#forwarding port
EXPOSE 80 22122 23000
#volume dir
#VOLUME ["$FASTDFSDIR"]
#set default command
ENTRYPOINT ["sh","/opt/startservice.sh"]

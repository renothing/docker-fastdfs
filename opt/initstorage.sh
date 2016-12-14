#!/bin/bash
SERVER=$1
IPCDIR=`ip ro ls dev eth0|awk '/src/{print $1}'`
[ -z "$DOMAIN" ] && DOMAIN=storage1.t.winshare.com
FASTDFSDIR=`awk -F: '{if ($1=="fastdfs"){print $(NF-1)}}' /etc/passwd`
mkdir -p $FASTDFSDIR/storage $FASTDFSDIR/storage/path0/
chown fastdfs:fastdfs -R $FASTDFSDIR/storage
sed -i "s/SERVER/$SERVER/g" /etc/fdfs/storage.conf /etc/fdfs/client.conf /etc/fdfs/mod_fastdfs.conf
sed -i "s/GROUP/$GROUP/g" /etc/fdfs/storage.conf /etc/fdfs/client.conf /etc/fdfs/mod_fastdfs.conf
sed -i "s#IPCDIR#$IPCDIR#g" /etc/fdfs/storage.conf
sed -i "s/DOMAIN/$DOMAIN/g" /etc/fdfs/storage.conf
sed -i "s#FASTDFSDIR#$FASTDFSDIR#g" /etc/fdfs/nginx.conf /etc/fdfs/storage.conf /etc/fdfs/mod_fastdfs.conf
cp -fp /etc/fdfs/nginx.conf /etc/nginx/nginx.conf

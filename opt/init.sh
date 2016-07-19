#!/bin/bash
IPADDR=`ip ro ls dev eth0|awk '/src/{print $NF}'`
IPCDIR=`ip ro ls dev eth0|awk '/src/{print $1}'`
DOMAIN=storage1.t.winshare.com
FASTDFSDIR=`awk -F: '{if ($1=="fastdfs"){print $(NF-1)}}' /etc/passwd`
mkdir -p $FASTDFSDIR/{tracker,storage} $FASTDFSDIR/storage/path0/
chown fastdfs:fastdfs -R $FASTDFSDIR
sed -i "s/IPADDR/$IPADDR/g" /etc/fdfs/storage.conf /etc/fdfs/client.conf /etc/fdfs/mod_fastdfs.conf
sed -i "s#IPCDIR#$IPCDIR#g" /etc/fdfs/storage.conf /etc/fdfs/tracker.conf
sed -i "s/DOMAIN/$DOMAIN/g" /etc/fdfs/storage.conf /etc/fdfs/storage_ids.conf
echo "$IPADDR $DOMAIN" >>/etc/hosts
sed -i "s#FASTDFSDIR#$FASTDFSDIR#g" /etc/fdfs/nginx.conf /etc/fdfs/storage.conf /etc/fdfs/tracker.conf
cp -fp /etc/fdfs/nginx.conf /etc/nginx/nginx.conf

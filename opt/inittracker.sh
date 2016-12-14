#!/bin/bash
IPADDR=`ip ro ls dev eth0|awk '/src/{print $NF}'`
IPCDIR=`ip ro ls dev eth0|awk '/src/{print $1}'`
[ -z "$DOMAIN" ] && DOMAIN=storage1.t.winshare.com
FASTDFSDIR=`awk -F: '{if ($1=="fastdfs"){print $(NF-1)}}' /etc/passwd`
mkdir -p $FASTDFSDIR/tracker 
chown fastdfs:fastdfs -R $FASTDFSDIR/tracker
sed -i "s/SERVER/$IPADDR/g" /etc/fdfs/client.conf 
sed -i "s#IPCDIR#$IPCDIR#g" /etc/fdfs/tracker.conf
sed -i "s#FASTDFSDIR#$FASTDFSDIR#g" /etc/fdfs/nginx.conf /etc/fdfs/tracker.conf /etc/fdfs/mod_fastdfs.conf

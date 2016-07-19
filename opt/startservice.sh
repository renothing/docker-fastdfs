#!/bin/bash
FASTDFSDIR=`awk -F: '{if ($1=="fastdfs"){print $(NF-1)}}' /etc/passwd`
test -d $FASTDFSDIR || bash /opt/init.sh
grep -q IPADDR /etc/fdfs/storage.conf && bash /opt/init.sh
/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf
/usr/sbin/nginx
/usr/sbin/sshd -D

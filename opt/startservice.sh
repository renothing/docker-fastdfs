#!/bin/bash
arg=$1
FASTDFSDIR=`awk -F: '{if ($1=="fastdfs"){print $(NF-1)}}' /etc/passwd`
exit_error(){
    echo "invalid tracker server"
    exit 1
}
cp -rf /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime 
echo "$TIMEZONE" > /etc/timezone
if [ -n "$arg" ];then
	nc -w 1 -z $arg 22122 || exit_error
	test -d $FASTDFSDIR/storage || bash /opt/initstorage.sh $arg
	grep -q SERVER /etc/fdfs/storage.conf && bash /opt/initstorage.sh $arg
	/usr/bin/fdfs_storaged /etc/fdfs/storage.conf
	/usr/sbin/nginx -g 'daemon off;'
else
	test -d $FASTDFSDIR/tracker || bash /opt/inittracker.sh
        grep -q IPCDIR /etc/fdfs/tracker.conf && bash /opt/inittracker.sh
	/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf
	/usr/sbin/nginx -g 'daemon off;'
fi

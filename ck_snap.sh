#!/bin/sh


dir=`mount | grep Backup | awk '{print $3}'`

if [ -d "$dir" ] ; then
    if [ -f "$dir/autosnap" ] ; then
        if [ -f "$dir/auitosnap.pid" ] ; then
            exit
        fi
        touch /media/Backups/autosnap.pid
        $dir/autosnap
        sync
        rm $dir/autosnap.pid
        umount $dir
    fi
fi

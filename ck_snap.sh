#!/bin/sh


dir=`mount | grep Backup | awk '{print $3}'`

if [ -d "$dir" ] ; then
    if [ -f "$dir/autosnap" ] ; then
        if [ -f "$dir/autosnap.pid" ] ; then
            exit
        fi
        touch "$dir/autosnap.pid"
        $dir/autosnap
        sync
        rm $dir/autosnap.pid
        umount $dir
    fi
fi

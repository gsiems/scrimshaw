#!/bin/sh

if [ -d "/media/Backups" ] ; then
    if [ -f "/media/Backups/autosnap" ] ; then
        if [ -f "/media/Backups/autosnap.pid" ] ; then
            exit
        fi
        touch /media/Backups/autosnap.pid
        /media/Backups/autosnap
        sync
        rm /media/Backups/autosnap.pid
        umount /media/Backups
    fi
fi

#!/bin/bash

DEST=/home/tmarques

if [ `id -u` -ne 0  ]
then
    echo "Script must be run as root!"
    exit 99
fi;

mv portage.sqfs portage.sqfs.old
cd /usr
mksquashfs portage/ /home/tmarques/portage.sqfs
#cp /home/tmarques/portage.sqfs $DEST
#chmod 644 $DEST/portage.sqfs 
chmod 644 /home/tmarques/portage.sqfs

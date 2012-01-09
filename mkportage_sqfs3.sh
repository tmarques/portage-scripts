#!/bin/bash

if [ `id -u` -ne 0  ]
then
    echo "Script must be run as root!"
    exit 99
fi;

DEST=/home/apache/websites/theserver/fastoo/
HOMEDIR=/home/tmarques

mv portage.sqfs3 portage.sqfs3.old
cd /usr
$HOMEDIR/squashfs3/mksquashfs portage/ $HOMEDIR/portage.sqfs3
cp $HOMEDIR/portage.sqfs3 $DEST
chmod 644 $DEST/portage.sqfs3
chmod 644 $HOMEDIR/portage.sqfs3

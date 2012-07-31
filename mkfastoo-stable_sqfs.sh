#!/bin/bash

MAINTREE="/usr/portage"
TREE="/home/tmarques/fastoo/fastoo-stable"
SQFS="/home/tmarques/fastoo/fastoo-stable.sqfs4"
SQFS3="/home/tmarques/fastoo/fastoo-stable.sqfs3"

if [ `id -u` -ne 0  ]
then
    echo "Script must be run as root!"
    exit 99
fi;

rsync -avH --delete-before $MAINTREE/profiles/* $TREE/profiles/
rsync -avH --delete-before --exclude=cache $MAINTREE/metadata/* $TREE/metadata/
rm -rf $TREE/metadata/cache/*
# Regenerate metadata
mount --bind $TREE $MAINTREE
emerge --metadata
umount $MAINTREE
find $TREE/* -type f -exec chmod 644 {} \;
find $TREE/* -type d -exec chmod 755 {} \;
chmod 755 $TREE
chown portage:portage $TREE
chown portage:portage $TREE/* -R

rm $SQFS
mksquashfs $TREE $SQFS -e .git
chmod 644 $SQFS
rm $SQFS3
/home/tmarques/olpc/squashfs3.4/squashfs-tools/mksquashfs $TREE $SQFS3 -e .git
chmod 644 $SQFS3

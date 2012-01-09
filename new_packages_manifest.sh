#!/bin/bash

# This script adds the new ebuilds
# missing in the Manifest file

for EBUILD in `ls *.ebuild` 
do
	if [ `cat Manifest | grep $EBUILD >> /dev/null; echo $?` -eq 1 ]
	then
		# Remove old ebuilds
		rm Manifest;
	fi
	REAL_SIZE=`ls -l $EBUILD | awk '{ printf "%s\n", $5 }';`
	MANIFEST_SIZE=`cat Manifest | grep $EBUILD | awk '{ printf "%s\n", $3 }';`
	if [ $REAL_SIZE != $MANIFEST_SIZE ]
	then
		echo $EBUILD;
	fi
		ebuild $EBUILD manifest;
done

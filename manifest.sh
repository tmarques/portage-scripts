#!/bin/bash
# This script adds the new ebuilds
# missing in the Manifest file

# EXIT values:
#   0 - OK
#  99 - Not running as root.

if [ `id -u` -ne 0 ]
then
    echo "Script must be run as root user!"
    exit 99
fi;

###
#
# Main Code
#
###

if [ ! $SCRIPT_DIR ];
then
	SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
fi;

echo $PWD
for EBUILD in `ls *.ebuild` 
do
	if [ -d files ];
	then
		sh $SCRIPT_DIR/portage-clean-files-dir.sh
	fi;
	
	REBUILD=0;
	if [ `cat Manifest | grep $EBUILD >> /dev/null; echo $?` -eq 1 ]
	then
		REBUILD=1;
	fi
	REAL_SIZE=`ls -l $EBUILD | awk '{ printf "%s\n", $5 }';`
	MANIFEST_SIZE=`cat Manifest | grep $EBUILD | awk '{ printf "%s\n", $3 }';`
	if [ "$REAL_SIZE" != "$MANIFEST_SIZE" ]
	then
		cat Manifest | grep -v $EBUILD > /tmp/Manifest;
		cp /tmp/Manifest ./;
		REBUILD=1;
	fi
	# Problems! Do fix them now:
	if [ "$REBUILD" -eq 1 ]
	then
		ebuild $EBUILD manifest;
	fi
done

chown portage:portage -R .
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
chmod 755 .

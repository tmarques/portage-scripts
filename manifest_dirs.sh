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

SCRIPT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

for DIR in `ls -l | grep drwx | awk '{ print $9 }'`
do
	cd $DIR;
	SCRIPT_DIR=$SCRIPT_DIR sh $SCRIPT_DIR/manifest.sh;
	cd ..;
done

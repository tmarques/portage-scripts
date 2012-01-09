#!/bin/bash

FILES=`ls files`
# Package name only, no version
PN=${PWD##*/}
PN_LENGTH=${#PN}
# Ebuild files from where package versions will
# be extracted.
PV_FILES=`ls *ebuild`

for PV_FILE in $PV_FILES;
do
	PV=${PV_FILE:$PN_LENGTH}
	PV=${PV%.ebuild*}
	# Remove ebuild revision number (-rX),
	# if it exists.
	if [ -n "${PV%-*}" ]
	then
		PV=${PV%-*}
	fi;
	PVS="$PVS $PV "
done

for FILE in $FILES;
do
	# Patch name without the package name
	FILE_WITHOUT_PN=${FILE:$PN_LENGTH}
	
	# Don't include package name in the files which start with it,
	# since portage adds it.
	if [ "$PN" = "${FILE:0:$PN_LENGTH}" ]
	then
		FILE_TO_ESCAPE=$FILE_WITHOUT_PN;
	else
		FILE_TO_ESCAPE=$FILE;
	fi;
	
	# Remove package version, if some patchs
	# have it the file name, since ebuilds
	# can also add it by the full package name.
	for PV in $PVS;
	do
		PV_LENGTH=${#PV}
		if [ "${PV}" = "${FILE_TO_ESCAPE:0:$PV_LENGTH}" ]
		then
			FILE_TO_ESCAPE=${FILE_TO_ESCAPE:$PV_LENGTH}
		fi;
	done
	
	# Escape dots and hyphen
	FILE_ESCAPED=${FILE_TO_ESCAPE/./\\.};
	FILE_ESCAPED=${FILE_TO_ESCAPE/-/\\-};
	
	# Go for it.
	`grep -rs "${FILE_ESCAPED}" *ebuild files >> /dev/null;`
	IN_USE=$?;

	if [ ! $IN_USE == "0" ]
	then
		echo "Deleting files/$FILE";
		rm files/$FILE
	fi
done

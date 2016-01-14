#!/bin/sh
## Copyright (c) 2014 Minoca Corp. All Rights Reserved.
##
## Script Name:
##
##     upload_binaries.sh
##
## Abstract:
##
##     This script uploads the bin archive. SRCROOT, ARCH and DEBUG must be set.
##
## Author:
##
##     Evan Green 14-May-2014
##
## Environment:
##
##     Minoca (Windows) Build
##

set -e
SAVE_IFS="$IFS"
IFS='
'

export SRCROOT=`echo $SRCROOT | sed 's_\\\\_/_g'`
IFS="$SAVE_IFS"
unset SAVE_IFS

if test -z $SRCROOT; then
    echo "SRCROOT must be set."
    exit 1
fi

if test -z $ARCH; then
    echo "ARCH must be set."
    exit 1
fi

if test -z $DEBUG; then
    echo "DEBUG must be set."
    exit 1
fi

export TMPDIR=$PWD
export TEMP=$TMPDIR
export PATH="$SRCROOT/tools/win32/mingw/bin;$SRCROOT/tools;$SRCROOT/$ARCH$DEBUG/bin;$SRCROOT/$ARCH$DEBUG/testbin;$SRCROOT/$ARCH$DEBUG/bin/tools/bin;$SRCROOT/tools/win32/scripts;$SRCROOT/tools/win32/swiss;$SRCROOT/tools/win32/bin;$SRCROOT/tools/win32/ppython/app;$SRCROOT/tools/win32/ppython/App/Scripts;$PATH"
file=minoca-bin-${ARCH}${DEBUG}-win32.tar.gz
file_size=`ls -l $file | \
    sed -n 's/[^ ]* *[^ ]* *[^ ]* *[^ ]* *\([0123456789]*\).*/\1/p'`

python $SRCROOT/client.py --result "Windows Binaries Size" integer "$file_size"
python $SRCROOT/client.py --upload schedule $file $file
echo Uploaded file $file, size $file_size
rm $file


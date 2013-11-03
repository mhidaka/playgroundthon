#!/bin/sh
ISERROR=0

if [ "${KLB_PLAYGROUND_HOME}" = "" ] ; then
    echo "set environment variable KLB_PLAYGROUND_HOME"
    ISERROR=1
fi

if [ $ISERROR == 1 ] ; then
    exit
fi

mono $KLB_PLAYGROUND_HOME/Tools/Toboggan/KLBToolHost.exe --verbose --clean --publish --force --all-profiles --directory attack-on-deadline

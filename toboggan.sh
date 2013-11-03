#!/bin/sh
ISERROR=0

if [ "${KLB_PLAYGROUND_HOME}" = "" ] ; then
    echo "set environment variable KLB_PLAYGROUND_HOME"
    ISERROR=1
fi

if [ $ISERROR = 1 ] ; then
    exit
fi

cd attack-on-deadline
mono $KLB_PLAYGROUND_HOME/Tools/Toboggan/KLBToolHost.exe --verbose --clean --publish --force --all-profiles --plugin-vars KLBTextureEditor_Plugin.ENABLE_COMPRESSION=1 --directory `pwd`
cd .publish/android
ANDROID_ASSETS_DIR=../../../android-assets
zip -r -9 $ANDROID_ASSETS_DIR/AppAssets.zip ./*
md5 -q $ANDROID_ASSETS_DIR/AppAssets.zip > $ANDROID_ASSETS_DIR/version

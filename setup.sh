#!/bin/bash

WORK_DIR=`pwd`

# set to true if you want to replace CM recovery with TWRP recovery
if false; then
    if [ ! -d bionic ]; then
        echo "This script must be executed from the CyanogenMod root directory"
        exit
    fi

    # TWRP does not built correctly in CM branch atm
    echo "Replacing recovery with TWRP"
    cd bootable
    mv recovery recovery.orig
    git clone https://github.com/omnirom/android_bootable_recovery recovery.twrp || exit 1
    ln -s recovery.twrp recovery
    cd recovery
    git checkout android-6.0 || exit 1
    cd $WORK_DIR
fi

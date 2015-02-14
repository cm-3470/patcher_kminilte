#!/bin/bash

# Grab all Samsung Galaxy S5 mini (G800F) patches

# BUILD
cd build

# Recovery: remove wiping of res folder
#git fetch https://github.com/omnirom/android_build.git android-5.0
#git cherry-pick 12df78d8848325537d64ff0d0370aac6af203866
cd -

# FRAMEWORK
cd frameworks/av

# Add Samsung WFD Service -- required for HWComposer
git fetch https://github.com/cm-gardalte/android_frameworks_av.git cm-12.0
git cherry-pick d4848efbd5650a48f93a784e5de248a13b830c04
cd -

cd frameworks/native

# Revert "Remove Parcel::writeIntPtr."
git fetch https://github.com/cm-gardalte/android_frameworks_native.git cm-12.0
git cherry-pick ce3244f93e8c42ba0f67b449647d2c2e2b5c2f76
cd -

cd frameworks/base

# Fix volume key music controls and wake up
#git fetch https://github.com/cm-gardalte/android_frameworks_base.git cm-12.0
#git cherry-pick f92549d029b64a6a822d155cf76179f1e280bdcd
cd -

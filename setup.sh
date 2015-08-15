#!/bin/bash

WORK_DIR=`pwd`

CM_BRANCH=cm-12.1

if [ ! -d bionic ]; then
  echo "This script must be executed from the CyanogenMod root directory"
  exit
fi

function git-patch {
  if git ls-remote $1 &> /dev/null; then
    echo "Remote already exists"
  else
    git remote add $1 $2 || return 1
  fi
  
  #git reset --hard github/$3
  #echo
  
  #git cherry github/$3 cm-3470/$3
  
  git pull --no-edit $1 $3 || return 2
  git rebase github/$3 || return 3
}

# Grab all Samsung Galaxy S5 mini (G800F) patches

# recovery might be replaced by TWRP -> only patch if CM recovery is used
echo "Patching bootable/recovery"
cd bootable/recovery
recovery_url=`git config --get remote.github.url`
if [ "$recovery_url" = "https://github.com/CyanogenMod/android_bootable_recovery" ]; then
  git-patch cm-3470 https://github.com/cm-3470/android_bootable_recovery.git $CM_BRANCH || exit 1
else
  echo "WARN: Recovery does not seem to be CM one -> patches will not be applied"
fi
cd $WORK_DIR

# list of repositories with custom patches
declare -A repos
repos=(
    ["frameworks/av"]="https://github.com/cm-3470/android_frameworks_av.git"
    ["frameworks/base"]="https://github.com/cm-3470/android_frameworks_base.git"
    ["frameworks/native"]="https://github.com/cm-3470/android_frameworks_native.git"
    ["frameworks/opt/telephony"]="https://github.com/cm-3470/android_frameworks_opt_telephony.git"
    ["packages/apps/Camera2"]="https://github.com/cm-3470/android_packages_apps_Camera2.git"
)

# apply patches on selected repositories
for repo in "${!repos[@]}"; do
  echo "Patching $repo"  
  cd $repo
  git-patch cm-3470 ${repos[$repo]} $CM_BRANCH || exit 1
  cd $WORK_DIR
done

# set to true if you want to replace CM recovery with TWRP recovery
if false; then
    echo "Replacing recovery with TWRP"
    cd bootable
    mv recovery recovery.orig
    git clone https://github.com/omnirom/android_bootable_recovery recovery.twrp || exit 1
    ln -s recovery.twrp recovery
    cd recovery
    git checkout android-5.1 || exit 1
    cd $WORK_DIR
fi

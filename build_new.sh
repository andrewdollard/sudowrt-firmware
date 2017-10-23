#!/bin/bash

set -e

ARCHITECTURE=$1
BUILD_DIR=built_firmware
WORK_DIR=openwrt_config

if [ -z $ARCHITECTURE ]; then 
  echo "Please provide an architecture"
  exit 1
fi

if [ ! -d $WORK_DIR ]; then
  echo "Invalid working directory"
  exit 1
fi

REVISION=$(git log --pretty=format:'%H' -n1)
ALL_PACKAGES=$(cat openwrt_config/packages)

OPENWRT_VERSION=$(cat openwrt_config/version)
OPENWRT_PATH=$(echo "${OPENWRT_VERSION}" | cut -d ':' -f 1)
OPENWRT_REV=$(echo "${OPENWRT_VERSION}" | cut -d ':' -f 2)
OPENWRT_CHECKOUT_DIR="$(pwd)/$BUILD_DIR/openwrt"

if [ ! -d $OPENWRT_CHECKOUT_DIR ]; then
  git clone "git://git.openwrt.org/${OPENWRT_PATH}/openwrt.git" "${OPENWRT_CHECKOUT_DIR}"
fi
(cd $OPENWRT_CHECKOUT_DIR && git checkout $OPENWRT_REV)

cat /dev/null > "${OPENWRT_CHECKOUT_DIR}/feeds.conf"
while read -r line
do
  IFS=: read -a ARRAY <<< "${line}"
  feed_title=${ARRAY[*]:0:1}

  SAVE_IFS=$IFS
  IFS=":"
  feed_source="${ARRAY[*]:1}"
  IFS=$SAVE_IFS

  echo "${feed_source}"  >> "${OPENWRT_CHECKOUT_DIR}/feeds.conf"
done < "${WORK_DIR}/feeds"

echo "Applying patches for OpenWRT base tree..."
cd "${OPENWRT_CHECKOUT_DIR}"
if [ ! -h "patches" ] ; then
  ln -s "../../openwrt_patches" patches
fi
if [ ! -f "patches/series" ] ; then
  quilt import patches/*
fi

quilt push -f -a -q || [ $? -eq 2 ] #quilt returns a 2 if there is nothing more to do


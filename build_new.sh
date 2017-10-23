#!/bin/bash

set -e

ARCHITECTURE=$1
BUILD_DIR=built_firmware
WORK_DIR=openwrt_config

if [ -z $ARCHITECTURE ]; then 
  echo "Please provide an architecture"
fi

if [ ! -d $WORK_DIR ]; then
  echo "Invalid working directory"
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


feedlines=()
while read -r line
do
  feedlines+=($line)
done < "${WORK_DIR}/feeds"

feed_titles=()
feed_sources=()
for feedline in "${feedlines[@]}"; do
  IFS=: read -a ARRAY <<< "${feedline}"
  feed_title=${ARRAY[*]:0:1}
  # feed_titles+=($feed_title)
  feed_titles=("${feed_titles[@]}" "${feed_title}")

  SAVE_IFS=$IFS
  IFS=":"
  feed_source="${ARRAY[*]:1}"
  IFS=$SAVE_IFS

  feed_sources=("${feed_sources[@]}" "${feed_source}")
done
echo ${feed_titles[*]}
echo ${feed_sources[*]}

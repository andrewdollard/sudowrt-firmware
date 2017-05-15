#!/bin/bash

arch=$1
if [ -z "$arch" ]
then
  arch="ar71xx"
fi
time ./build $arch

# aws s3 cp $FIRMWARE_DIR/built_firmware/builder.$arch/build.log  s3://amd-sudowrt-builds/$CI_PLATFORM
# aws s3 cp --recursive $FIRMWARE_DIR  s3://amd-sudowrt-builds/

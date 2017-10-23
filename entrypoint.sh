#!/bin/bash

# arch=$1
# if [ -z "$arch" ]
# then
#   arch="ar71xx"
# fi
# time ./build $arch
#
# # aws s3 cp $FIRMWARE_DIR/built_firmware/builder.$arch/build.log  s3://amd-sudowrt-builds/$CI_PLATFORM
# aws s3 cp --recursive $FIRMWARE_DIR  s3://amd-sudowrt-builds/

# this is part is an attempt at generalizing, took too long to test 
build="build"
architecture=$1
directory="ar71xx"
if [ -z "$architecture" ]
then
  architecture="ar71xx"
elif [ "$architecture" = "ar71xx.extender-node" ]
then
  build="build_extender-node"
  directory="ar71xx.extender-node"
fi
#end of generalization attempt

# this is the current method which is hardcoded, but works
time ./build ar71xx
time ./build_extender-node ar71xx
mkdir -p ./firmware_images
read -p "Check for home node images"
cp -r ./built_firmware/builder.ar71xx/bin/ar71xx/ /firmware_images
read -p "Check for extender node images"
cp -r ./built_firmware/builder.ar71xx.extender-node/bin/ /firmware_images

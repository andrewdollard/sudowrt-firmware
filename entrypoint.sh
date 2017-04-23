#!/bin/bash

arch=$1
if [ -z "$arch" ]
then
  arch="ar71xx"
fi
# chown -R builder .
# su -l builder
# time ./build $arch

echo ls ./built_firmware/builder.$arch/
echo $(ls ./built_firmware/builder.$arch/)
aws s3 cp $FIRMWARE_DIR/README.md s3://amd-sudowrt-builds/
# cp -r $FIRMWARE_DIR/built_firmware/builder.$arch/build.log /firmware_images
# cp -r $FIRMWARE_DIR/built_firmware/builder.$arch/bin /firmware_images

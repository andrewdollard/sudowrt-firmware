#!/bin/bash

echo $PWD
echo $(ls)
arch=$1
if [ -z "$arch" ]
then
  arch="ar71xx"
fi
time ./build $arch

echo $(ls ./built_firmware/builder.$arch/)
cp -r $FIRMWARE_DIR/built_firmware/builder.$arch/build.log /firmware_images
cp -r $FIRMWARE_DIR/built_firmware/builder.$arch/bin /firmware_images
exec bash

#!/bin/bash

echo $PWD
echo $(ls)
arch=$1
if [ -z "$arch" ]
then
  arch="ar71xx"
fi
runuser -l builder -c 'time ./build $arch'

echo $(ls ./built_firmware/builder.$arch/)
cp -r $FIRMWARE_DIR/built_firmware/builder.$arch/bin /firmware_images

#!/bin/bash

arch=$1
if [ -z "$arch" ]
then
  arch="ar71xx"
fi
chown -R builder .
su -l builder
time ./build $arch

aws s3 cp --recursive $FIRMWARE_DIR/  s3://amd-sudowrt-builds/

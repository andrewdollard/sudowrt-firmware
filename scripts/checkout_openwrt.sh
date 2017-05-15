#!/bin/bash

openwrt_version=$(cat openwrt_config/version)
openwrt_path=$(echo "${openwrt_version}" | cut -d ':' -f 1)
openwrt_rev=$(echo "${openwrt_version}" | cut -d ':' -f 2)

OPENWRT_CHECKOUT_DIR="${workdir}/${BUILD_DIR}/openwrt"
echo "OpenWRT path: ${openwrt_path}"
echo "OpenWRT revision: ${openwrt_rev}"

rm -rf "${OPENWRT_CHECKOUT_DIR}"
git clone "git://git.openwrt.org/${openwrt_path}/openwrt.git" "${OPENWRT_CHECKOUT_DIR}"
cd "${OPENWRT_CHECKOUT_DIR}"
git checkout "${openwrt_rev}"
cd "${workdir}"

if [ $? -ne 0 ]; then
  echo "Error during svn checkout of OpenWRT"
  exit $?
fi

rm -f "${workdir}/${BUILD_DIR}/openwrt/.config"

#!/bin/bash

# Inject feeds and configurations
echo "Configuring feeds"

feedlines=()
feed_file="${workdir}/openwrt_config/feeds"
while read -r line
do
  feedlines=("${feedlines[@]}" "${line}")
done < "$feed_file"

feed_titles=()
feed_sources=()
for feedline in "${feedlines[@]}"; do
  IFS=: read -a ARRAY <<< "${feedline}"
  feed_title=${ARRAY[*]:0:1}
  feed_titles=("${feed_titles[@]}" "${feed_title}")

  SAVE_IFS=$IFS
  IFS=":"
  feed_source="${ARRAY[*]:1}"
  IFS=$SAVE_IFS

  feed_sources=("${feed_sources[@]}" "${feed_source}")
done

cat /dev/null > "${OPENWRT_CHECKOUT_DIR}/feeds.conf"
for feed_source in "${feed_sources[@]}"; do
  echo "${feed_source}"  >> "${OPENWRT_CHECKOUT_DIR}/feeds.conf"
done


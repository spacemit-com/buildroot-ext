#!/bin/bash

######################## post process uboot-spl ####################
#change to this script's dir, otherwise exec failed
#cd $(dirname $0)

#$1 is buildroot output target dir
BUILDROOT_IMAGES_DIR="$(dirname $1)/images"
OVERRIDE_ROOTFS_FILE="$(dirname $0)/rootfs.ext4"
TARGET_ROOTFS_FILE="$BUILDROOT_IMAGES_DIR/rootfs.ext2"

if [ -f "$OVERRIDE_ROOTFS_FILE" ]; then
    cp -rf ${OVERRIDE_ROOTFS_FILE} ${TARGET_ROOTFS_FILE}
    echo "override ${TARGET_ROOTFS_FILE} with ${OVERRIDE_ROOTFS_FILE} success"
fi
exit 0



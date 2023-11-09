#!/bin/bash

######################## prepare img to be packed ####################
#$0 is this file path
#$1 is buildroot output target dir

BUILDROOT_IMAGES_DIR="$(dirname $1)/images"
#UNSIGN_IMAGES_DIR="$(dirname $1)/unsign-firmware"
#SIGNED_IMAGES_DIR="$(dirname $1)/signed-firmware"
OVERRIDE_ROOTFS_FILE="$(dirname $0)/rootfs.ext4"
FSBL_YML_FILE="$(dirname $0)/fsbl.yml"
UBOOT_FIT_FILE="$(dirname $0)/uboot-fit.its"
OPENSBI_FIT_FILE="$(dirname $0)/opensbi-fit.its"

TARGET_ROOTFS_FILE="$BUILDROOT_IMAGES_DIR/rootfs.ext2"
TARGET_BOOTFS_FILE="$BUILDROOT_IMAGES_DIR/bootfs.img"

#override rootfs.ext4
if [ -f "$OVERRIDE_ROOTFS_FILE" ]; then
    cp -rf ${OVERRIDE_ROOTFS_FILE} ${TARGET_ROOTFS_FILE}
    echo "override ${TARGET_ROOTFS_FILE} with ${OVERRIDE_ROOTFS_FILE} success"
fi

#create header for uboot-spl.bin and rename to FSBL.bin
rm ${BUILDROOT_IMAGES_DIR}/FSBL.bin
cp -f ${FSBL_YML_FILE} ${BUILDROOT_IMAGES_DIR}/
python3 ../scripts/build_binary_file.py -c ${BUILDROOT_IMAGES_DIR}/fsbl.yml -o ${BUILDROOT_IMAGES_DIR}/FSBL.bin
rm ${BUILDROOT_IMAGES_DIR}/fsbl.yml

#copy uboot its file and mk itb
rm ${BUILDROOT_IMAGES_DIR}/uboot-fit.itb
cp -f ${UBOOT_FIT_FILE} ${BUILDROOT_IMAGES_DIR}/uboot-fit.its
mkimage -f ${BUILDROOT_IMAGES_DIR}/uboot-fit.its -r ${BUILDROOT_IMAGES_DIR}/uboot-fit.itb
rm ${BUILDROOT_IMAGES_DIR}/uboot-fit.its

#copy opensbi its file and mk itb
rm ${BUILDROOT_IMAGES_DIR}/opensbi-fit.itb
cp -f ${OPENSBI_FIT_FILE} ${BUILDROOT_IMAGES_DIR}/opensbi-fit.its
mkimage -f ${BUILDROOT_IMAGES_DIR}/opensbi-fit.its -r ${BUILDROOT_IMAGES_DIR}/opensbi-fit.itb
rm ${BUILDROOT_IMAGES_DIR}/opensbi-fit.its


#copy bootfs img
#ln -s ${TARGET_BOOTFS_FILE}  ${UNSIGN_IMAGES_DIR}/bootfs.img

#copy rootfs img
#ln -s ${TARGET_ROOTFS_FILE}  ${UNSIGN_IMAGES_DIR}/rootfs.ext4



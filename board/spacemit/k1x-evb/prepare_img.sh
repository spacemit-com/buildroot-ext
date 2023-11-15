#!/bin/bash

######################## prepare img to be packed ####################
#$0 is this file path
#$1 is buildroot output images dir

IMGS_DIR=$1
CFG_DIR=$(dirname $0)
#UNSIGN_IMAGES_DIR="$(dirname $1)/unsign-firmware"
#SIGNED_IMAGES_DIR="$(dirname $1)/signed-firmware"
OVERRIDE_ROOTFS_FILE="$CFG_DIR/rootfs.ext4"
FSBL_YML_FILE="$CFG_DIR/fsbl.yml"
UBOOT_FIT_FILE="$CFG_DIR/uboot_fit.its"
OPENSBI_FIT_FILE="$CFG_DIR/opensbi_fit.its"
PARTITIONS_FILE="$CFG_DIR/partitions.json"
GENIMAGE_CFG_FILE="$CFG_DIR/sd-genimage.cfg"

TARGET_ROOTFS_FILE="$IMGS_DIR/rootfs.ext2"
TARGET_BOOTFS_FILE="$IMGS_DIR/bootfs.img"

#override rootfs.ext4
if [ -f "$OVERRIDE_ROOTFS_FILE" ]; then
    cp -rf ${OVERRIDE_ROOTFS_FILE} ${TARGET_ROOTFS_FILE}
    echo "override ${TARGET_ROOTFS_FILE} with ${OVERRIDE_ROOTFS_FILE} success"
fi

#create header for uboot-spl.bin and rename to FSBL.bin
rm ${IMGS_DIR}/FSBL.bin
cp -f ${FSBL_YML_FILE} ${IMGS_DIR}/
python3 ../scripts/build_binary_file.py -c ${IMGS_DIR}/fsbl.yml -o ${IMGS_DIR}/FSBL.bin
rm ${IMGS_DIR}/fsbl.yml

#copy uboot its file and mk itb
rm ${IMGS_DIR}/u-boot.itb
cp -f ${UBOOT_FIT_FILE} ${IMGS_DIR}/uboot_fit.its
$IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/uboot_fit.its -r ${IMGS_DIR}/u-boot.itb
rm ${IMGS_DIR}/uboot_fit.its

#copy opensbi its file and mk itb
rm ${IMGS_DIR}/opensbi.itb
cp -f ${OPENSBI_FIT_FILE} ${IMGS_DIR}/opensbi_fit.its
$IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/opensbi_fit.its -r ${IMGS_DIR}/opensbi.itb
rm ${IMGS_DIR}/opensbi_fit.its

#update sd-geimage.cfg
../scripts/gen_imgcfg.py  ${PARTITIONS_FILE}
mv ./genimage.cfg ${GENIMAGE_CFG_FILE}

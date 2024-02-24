#!/bin/bash

######################## Prepare sub-iamges and pack ####################
#$0 is this file path
#$1 is buildroot output images dir

IMGS_DIR=$1
DEVICE_DIR=$(dirname $0)

SRC_ROOTFS_FILE="$DEVICE_DIR/rootfs.ext4"
FSBL_YML_FILE="$DEVICE_DIR/fsbl.yml"
KERNEL_FIT_FILE="$DEVICE_DIR/kernel_fdt.its"
PARTITIONS_FILE="$DEVICE_DIR/partition_universal.json"
UENV_TXT_FILE="$DEVICE_DIR/env_k1-x.txt"
UBOOT_LOGO_FILE="$DEVICE_DIR/k1-x.bmp"

#Give a chance to CI
if [ -z "$BIANBU_LINUX_ARCHIVE" ]; then
    TARGET_IMAGE_ZIP="$IMGS_DIR/spacemit_bianbu_linux_k1_emmc_pack_image.zip"
else
    TARGET_IMAGE_ZIP="$BIANBU_LINUX_ARCHIVE.zip"
fi

TARGET_ROOTFS_FILE="$IMGS_DIR/rootfs.ext2"
TARGET_BOOTFS_FILE="$IMGS_DIR/bootfs.img"
#TARGET_INITRAMFS_FILE=("$IMGS_DIR/rootfs.cpio.gz")
TARGET_INITRAMFS_FILE=("$IMGS_DIR/rootfs.cpio.uboot")

BOOTFS_SIZE=$($IMGS_DIR/../host/bin/jq '.partitions[] | select(.name == "bootfs") | .size' "$PARTITIONS_FILE")
BOOTFS_DIR="$IMGS_DIR/bootfs"
BOOTFS_IMG_FILE="$IMGS_DIR/bootfs.img"

KERNEL_DTB_NAME="k1-x*.dtb"
KERNEL_DTB_FILE="$IMGS_DIR/$KERNEL_DTB_NAME"
KERNEL_IMAGE_FILE="$IMGS_DIR/uImage.itb"

FAKE_ROOT_FILE=/tmp/$(whoami)-fakeroot

#Pack kernel image and initramfs
gen_bootfs_vfat() {
    echo -e "\n"
    echo "Starting to build bootfs ..............................."

    echo "#!/bin/sh" > "$FAKE_ROOT_FILE"
    echo "set -e" >> "$FAKE_ROOT_FILE"
    echo "rm -rf $BOOTFS_DIR" >> "$FAKE_ROOT_FILE"
    echo "mkdir -p $BOOTFS_DIR" >> "$FAKE_ROOT_FILE"

    echo "rm -f $BOOTFS_IMG_FILE" >> "$FAKE_ROOT_FILE"
    echo "dd if=/dev/zero of=$BOOTFS_IMG_FILE count=1 bs=$BOOTFS_SIZE" >> "$FAKE_ROOT_FILE"
    echo "mkfs.vfat $BOOTFS_IMG_FILE" >> "$FAKE_ROOT_FILE"

    echo "cp -f $UENV_TXT_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $UBOOT_LOGO_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $KERNEL_IMAGE_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $KERNEL_DTB_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $TARGET_INITRAMFS_FILE $BOOTFS_DIR/initramfs-generic.img" >> "$FAKE_ROOT_FILE"
    echo "mcopy -i $BOOTFS_IMG_FILE $BOOTFS_DIR/* ::" >> "$FAKE_ROOT_FILE"

    chmod 777 "$FAKE_ROOT_FILE"
    FAKEROOTDONTTRYCHOWN=1 "$IMGS_DIR/../host/bin/fakeroot" -- "$FAKE_ROOT_FILE"

    if [ $? -ne 0 ]; then
        echo "Building bootfs failed. Please check for errors..............."
        exit 1
    fi
    echo "Bootfs build successful................................."
    echo -e "\n"
}

override_rootfs_img() {
    #override rootfs.ext4 if needed
    if [ -f "$SRC_ROOTFS_FILE" ]; then
        cp -rf ${SRC_ROOTFS_FILE} ${TARGET_ROOTFS_FILE}
        echo "Successfully overridden ${TARGET_ROOTFS_FILE} with ${SRC_ROOTFS_FILE}"
    fi
}

gen_sub_images() {

    #env.bin
    rm -f ${IMGS_DIR}/env_k1-x.txt
    cp -f ${UENV_TXT_FILE} ${IMGS_DIR}/
    $IMGS_DIR/../host/bin/mkenvimage -s 0x4000 -o ${IMGS_DIR}/env.bin ${IMGS_DIR}/env_k1-x.txt
    rm ${IMGS_DIR}/env_k1-x.txt

    #Rename to opensbi.itb for the partition file
    cp -f ${IMGS_DIR}/fw_dynamic.itb ${IMGS_DIR}/opensbi.itb

    #Gen kernel Image dtb here
    rm -f ${IMGS_DIR}/uImage.itb
    cp -f ${KERNEL_FIT_FILE} ${IMGS_DIR}/kernel_fdt.its
    $IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/kernel_fdt.its -r ${IMGS_DIR}/uImage.itb
    rm ${IMGS_DIR}/kernel_fdt.its

}

update_genimage_cfg() {
    #Update sd-geimage.cfg
    $PWD/../scripts/gen_imgcfg.py  ${PARTITIONS_FILE}
    mv $PWD/./genimage.cfg ${IMGS_DIR}/genimage.cfg
}

gen_sdcard_img() {
    echo "Generating sdcard.img..................................."
    $PWD/support/scripts/genimage.sh -c ${IMGS_DIR}/genimage.cfg
    if [ $? -ne 0 ]; then
        echo "Generating bootfs failed. Please check for errors..............."
        exit 1
    fi
    echo "sdcard.img successfully generated at ${IMGS_DIR}/sdcard.img"
}

pack_image_zip() {
    echo "Starting to pack images................................."
    rm -f ${TARGET_IMAGE_ZIP}
    rm -rf ${IMGS_DIR}/factory

    mkdir -p ${IMGS_DIR}/factory
    cp -f ${IMGS_DIR}/FSBL.bin ${IMGS_DIR}/factory/
    cp -f ${IMGS_DIR}/bootinfo_*.bin ${IMGS_DIR}/factory/
    
    cp -f ${DEVICE_DIR}/fastboot.yaml ${IMGS_DIR}/
    cp -f ${DEVICE_DIR}/partition_*.json ${IMGS_DIR}/
    #cp -f ${DEVICE_DIR}/partition_universal.json ${IMGS_DIR}/
    cd ${IMGS_DIR}
    zip ${TARGET_IMAGE_ZIP} \
        opensbi.itb \
        u-boot.itb \
        env.bin \
        bootfs.img \
        rootfs.ext4 \
        partition_*.json \
        fastboot.yaml \
        genimage.cfg \
        -r factory

    #Give a chance to CI
    if [ -n "$BIANBU_LINUX_ARCHIVE_LATEST" ]; then
        ln -sf ${TARGET_IMAGE_ZIP} $BIANBU_LINUX_ARCHIVE_LATEST
    fi

    #rm -f fastboot.yaml \
    #    partition_2M.json
    #    partition_universal.json \
    cd - >/dev/null
 
    echo "Images successfully packed into ${TARGET_IMAGE_ZIP}"
    echo -e "\n"
}


#FSBL opensbi uboot uImage
gen_sub_images

#Gen bootfs
gen_bootfs_vfat

#For Debian or Ubuntu rootfs override
override_rootfs_img

#Update genimage cfg because pack_image_zip dependis on it
update_genimage_cfg

#Pack images in zip
pack_image_zip

#Gen sdcard.img if need
gen_sdcard_img


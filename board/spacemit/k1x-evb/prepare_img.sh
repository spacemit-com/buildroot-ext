#!/bin/bash

######################## prepare sub img to be packed ####################
#$0 is this file path
#$1 is buildroot output images dir

IMGS_DIR=$1
DEVICE_DIR=$(dirname $0)

SRC_ROOTFS_FILE="$DEVICE_DIR/rootfs.ext4"
FSBL_YML_FILE="$DEVICE_DIR/fsbl.yml"
UBOOT_FIT_FILE="$DEVICE_DIR/uboot_fit.its"
OPENSBI_FIT_FILE="$DEVICE_DIR/opensbi_fit.its"
PARTITIONS_FILE="$DEVICE_DIR/partitions.json"
GENIMAGE_CFG_FILE="$DEVICE_DIR/sd-genimage.cfg"

TARGET_ROOTFS_FILE="$IMGS_DIR/rootfs.ext2"
TARGET_BOOTFS_FILE="$IMGS_DIR/bootfs.img"
TARGET_INITRAMFS_FILE=("$IMGS_DIR/rootfs.cpio.*")

BOOTFS_SIZE=$($IMGS_DIR/../host/bin/jq '.partitions[] | select(.name == "bootfs") | .size' "$DEVICE_DIR/partitions.json")
BOOTFS_DIR="$IMGS_DIR/bootfs"
BOOTFS_IMG_FILE="$IMGS_DIR/bootfs.img"

KERNEL_DTB=$(sed 's/"//g' <<< "k1-x_evb")
KERNEL_DTB_NAME="$(basename "$KERNEL_DTB").dtb"
KERNEL_DTB_FILE="$IMGS_DIR/$KERNEL_DTB_NAME"
KERNEL_IMAGE_FILE="$IMGS_DIR/Image"

UENV_BIN_FILE="$IMGS_DIR/uboot-env.bin"
FAKE_ROOT_FILE=/tmp/fakeroot

#pack kernel Image and initramfs
gen_bootfs_vfat() {
    echo -e "\n"
    echo "start to make bootfs ..............................."

    echo "#!/bin/sh" > "$FAKE_ROOT_FILE"
    echo "set -e" >> "$FAKE_ROOT_FILE"
    echo "rm -rf $BOOTFS_DIR" >> "$FAKE_ROOT_FILE"
    echo "mkdir -p $BOOTFS_DIR" >> "$FAKE_ROOT_FILE"

    echo "rm -f $BOOTFS_IMG_FILE" >> "$FAKE_ROOT_FILE"
    echo "dd if=/dev/zero of=$BOOTFS_IMG_FILE count=1 bs=$BOOTFS_SIZE" >> "$FAKE_ROOT_FILE"
    echo "mkfs.vfat $BOOTFS_IMG_FILE" >> "$FAKE_ROOT_FILE"

    echo "cp -f $UENV_BIN_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $KERNEL_IMAGE_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $KERNEL_DTB_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $TARGET_INITRAMFS_FILE $BOOTFS_DIR/initramfs-generic.img" >> "$FAKE_ROOT_FILE"
    echo "mcopy -i $BOOTFS_IMG_FILE $BOOTFS_DIR/* ::" >> "$FAKE_ROOT_FILE"

    chmod 777 "$FAKE_ROOT_FILE"
    FAKEROOTDONTTRYCHOWN=1 "$IMGS_DIR/../host/bin/fakeroot" -- "$FAKE_ROOT_FILE"
    echo "make bootfs success..............................."
    echo -e "\n"
}

override_rootfs_img() {
    #override rootfs.ext4 if needed
    if [ -f "$SRC_ROOTFS_FILE" ]; then
        cp -rf ${SRC_ROOTFS_FILE} ${TARGET_ROOTFS_FILE}
        echo "override ${TARGET_ROOTFS_FILE} with ${SRC_ROOTFS_FILE} success"
    fi
}

gen_sub_images() {
    #create header for uboot-spl.bin and rename to FSBL.bin
    rm -f ${IMGS_DIR}/FSBL.bin
    cp -f ${FSBL_YML_FILE} ${IMGS_DIR}/
    python3 $PWD/../scripts/build_binary_file.py -c ${IMGS_DIR}/fsbl.yml -o ${IMGS_DIR}/FSBL.bin
    rm ${IMGS_DIR}/fsbl.yml

    #copy uboot its file and gen itb
    rm -f ${IMGS_DIR}/u-boot.itb
    cp -f ${UBOOT_FIT_FILE} ${IMGS_DIR}/uboot_fit.its
    $IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/uboot_fit.its -r ${IMGS_DIR}/u-boot.itb
    rm ${IMGS_DIR}/uboot_fit.its

    #copy opensbi its file and gen itb
    rm -f ${IMGS_DIR}/opensbi.itb
    cp -f ${OPENSBI_FIT_FILE} ${IMGS_DIR}/opensbi_fit.its
    $IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/opensbi_fit.its -r ${IMGS_DIR}/opensbi.itb
    rm ${IMGS_DIR}/opensbi_fit.its

    #maybe gen kernel Image dtb here

    #gen bootfs
    gen_bootfs_vfat
}

update_geimage_cfg() {
    #update sd-geimage.cfg
    $PWD/../scripts/gen_imgcfg.py  ${PARTITIONS_FILE}
    mv $PWD/./genimage.cfg ${GENIMAGE_CFG_FILE}
}

gen_sub_images
update_geimage_cfg
override_rootfs_img
#now everything is ready, wait to call genimage.sh if needed

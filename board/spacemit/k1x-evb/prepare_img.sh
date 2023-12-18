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
KERNEL_FIT_FILE="$DEVICE_DIR/kernel_fdt.its"
PARTITIONS_FILE="$DEVICE_DIR/partition_universal.json"
GENIMAGE_CFG_FILE="$DEVICE_DIR/sd-genimage.cfg"
UENV_TXT_FILE="$DEVICE_DIR/env_k1-x.txt"

TARGET_IMAGE_ZIP="$IMGS_DIR/spacemit_bianbu_linux_k1-x_evb_emmc_pack_image.zip"
TARGET_ROOTFS_FILE="$IMGS_DIR/rootfs.ext2"
TARGET_BOOTFS_FILE="$IMGS_DIR/bootfs.img"
TARGET_INITRAMFS_FILE=("$IMGS_DIR/rootfs.cpio.*")

BOOTFS_SIZE=$($IMGS_DIR/../host/bin/jq '.partitions[] | select(.name == "bootfs") | .size' "$PARTITIONS_FILE")
BOOTFS_DIR="$IMGS_DIR/bootfs"
BOOTFS_IMG_FILE="$IMGS_DIR/bootfs.img"

KERNEL_DTB=$(sed 's/"//g' <<< "k1-x_evb")
KERNEL_DTB_NAME="$(basename "$KERNEL_DTB").dtb"
KERNEL_DTB_FILE="$IMGS_DIR/$KERNEL_DTB_NAME"
KERNEL_IMAGE_FILE="$IMGS_DIR/uImage.itb"

PACK_DIR=$IMGS_DIR/pack_image

FAKE_ROOT_FILE=/tmp/$(whoami)-fakeroot

#pack kernel Image and initramfs
gen_bootfs_vfat() {
    echo -e "\n"
    echo "Start to make bootfs ..............................."

    echo "#!/bin/sh" > "$FAKE_ROOT_FILE"
    echo "set -e" >> "$FAKE_ROOT_FILE"
    echo "rm -rf $BOOTFS_DIR" >> "$FAKE_ROOT_FILE"
    echo "mkdir -p $BOOTFS_DIR" >> "$FAKE_ROOT_FILE"

    echo "rm -f $BOOTFS_IMG_FILE" >> "$FAKE_ROOT_FILE"
    echo "dd if=/dev/zero of=$BOOTFS_IMG_FILE count=1 bs=$BOOTFS_SIZE" >> "$FAKE_ROOT_FILE"
    echo "mkfs.vfat $BOOTFS_IMG_FILE" >> "$FAKE_ROOT_FILE"

    echo "cp -f $UENV_TXT_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $KERNEL_IMAGE_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $KERNEL_DTB_FILE $BOOTFS_DIR/" >> "$FAKE_ROOT_FILE"
    echo "cp -f $TARGET_INITRAMFS_FILE $BOOTFS_DIR/initramfs-generic.img" >> "$FAKE_ROOT_FILE"
    echo "mcopy -i $BOOTFS_IMG_FILE $BOOTFS_DIR/* ::" >> "$FAKE_ROOT_FILE"

    chmod 777 "$FAKE_ROOT_FILE"
    FAKEROOTDONTTRYCHOWN=1 "$IMGS_DIR/../host/bin/fakeroot" -- "$FAKE_ROOT_FILE"
    echo "Making bootfs success..............................."
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
    #bootinfo_*.bin
    #rm -f ${IMGS_DIR}/bootinfo_sd.bin
    #cp -f ${FSBL_YML_FILE} ${IMGS_DIR}/
    #python3 $PWD/../scripts/build_binary_file.py -c ${IMGS_DIR}/fsbl.yml -o ${IMGS_DIR}/FSBL.bin
    #rm ${IMGS_DIR}/fsbl.yml
    #cp -f ${DEVICE_DIR}/bootinfo_sd.bin ${IMGS_DIR}/

    #create header for uboot-spl.bin and rename to FSBL.bin
    #rm -f ${IMGS_DIR}/FSBL.bin
    #cp -f ${FSBL_YML_FILE} ${IMGS_DIR}/
    #python3 $PWD/../scripts/build_binary_file.py -c ${IMGS_DIR}/fsbl.yml -o ${IMGS_DIR}/FSBL.bin
    #rm ${IMGS_DIR}/fsbl.yml
    #cp -f ${DEVICE_DIR}/FSBL.bin ${IMGS_DIR}/

    #env.bin
    rm -f ${IMGS_DIR}/env_k1-x.txt
    cp -f ${UENV_TXT_FILE} ${IMGS_DIR}/
    $IMGS_DIR/../host/bin/mkenvimage -s 0x4000 -o ${IMGS_DIR}/env.bin ${IMGS_DIR}/env_k1-x.txt
    rm ${IMGS_DIR}/env_k1-x.txt

    #copy uboot its file and gen itb
    rm -f ${IMGS_DIR}/u-boot.itb
    cp -f ${UBOOT_FIT_FILE} ${IMGS_DIR}/uboot_fit.its
    $IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/uboot_fit.its -r ${IMGS_DIR}/u-boot.itb
    rm ${IMGS_DIR}/uboot_fit.its

    #copy opensbi its file and gen itb
    #rm -f ${IMGS_DIR}/opensbi.itb
    #cp -f ${OPENSBI_FIT_FILE} ${IMGS_DIR}/opensbi_fit.its
    #$IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/opensbi_fit.its -r ${IMGS_DIR}/opensbi.itb
    #rm ${IMGS_DIR}/opensbi_fit.its

    #maybe gen kernel Image dtb here
    rm -f ${IMGS_DIR}/uImage.itb
    cp -f ${KERNEL_FIT_FILE} ${IMGS_DIR}/kernel_fdt.its
    $IMGS_DIR/../host/bin/mkimage -f ${IMGS_DIR}/kernel_fdt.its -r ${IMGS_DIR}/uImage.itb
    rm ${IMGS_DIR}/kernel_fdt.its

}

gen_sdcard_img() {
    #update sd-geimage.cfg
    echo "Generating sdcard.img..............................."
    $PWD/../scripts/gen_imgcfg.py  ${PARTITIONS_FILE}
    mv $PWD/./genimage.cfg ${GENIMAGE_CFG_FILE}
    cp -f ${GENIMAGE_CFG_FILE}  ${IMGS_DIR}/genimage.cfg
    $PWD/support/scripts/genimage.sh -c ${IMGS_DIR}/genimage.cfg
    rm -rf ${PACK_DIR}/genimage.cfg
}

pack_image_zip() {
    echo "Start to pack images................................"
    rm -f ${TARGET_IMAGE_ZIP}
    rm -rf ${IMGS_DIR}/factory

    cp -rf ${DEVICE_DIR}/factory ${IMGS_DIR}/
    cp -f ${DEVICE_DIR}/fastboot.yaml ${IMGS_DIR}/
    cp -f ${DEVICE_DIR}/partition_2M.json ${IMGS_DIR}/
    cp -f ${DEVICE_DIR}/partition_universal.json ${IMGS_DIR}/
    cd ${IMGS_DIR}
    zip ${TARGET_IMAGE_ZIP} \
        fw_dynamic.itb \
        u-boot.itb \
        bootfs.img \
        rootfs.ext4 \
        partition_2M.json \
        partition_universal.json \
        fastboot.yaml \
        -r factory
    
    rm -f partition_2M.json \
        partition_universal.json \
        fastboot.yaml
    cd - >/dev/null
    
    echo "Success to pack images into ${TARGET_IMAGE_ZIP}"
    echo -e "\n"
}

#FSBL opensbi uboot uImage
gen_sub_images

#gen bootfs
gen_bootfs_vfat

#for Debian or Ubuntu rootfs override
override_rootfs_img

#pack image in zip
pack_image_zip

#gen sdcard.img if need
gen_sdcard_img



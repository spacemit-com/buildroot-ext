################################################################################
#
# integrate initrd and kernel into boot image with fat32 filesystem.
#
################################################################################

# Not using the rootfs infra, so fake the variables
BOOTFS_SIZE = $(call qstrip, $(BR2_TARGET_BOOTFS_SIZE))
ifeq ($(BR2_TARGET_BOOTFS_SIZE)-$(BOOTFS_SIZE),y-)
$(error BR2_TARGET_BOOTFS_SIZE cannot be empty)
endif

#rootfs-cpio depend on linux
BOOTFS_DEPENDENCIES = rootfs-cpio host-e2fsprogs

IMAGE_OUT_PATH = $(patsubst %/,%,$(dir $(@)))
BOOTFS_DIR = $(IMAGE_OUT_PATH)/bootfs
BOOTFS_IMG = $(IMAGE_OUT_PATH)/bootfs.ext4
KERNEL_IMAGE_FILE = $(IMAGE_OUT_PATH)/Image
KERNEL_DTB_NAME = k1-x_fpga.dtb
KERNEL_DTB_FILE = $(IMAGE_OUT_PATH)/$(KERNEL_DTB_NAME)
UENV_FILE = $(IMAGE_OUT_PATH)/uEnv.txt

INITRAMFS_FILE = $@$(ROOTFS_CPIO_COMPRESS_EXT)
FAKE_ROOT_FILE = ../buildroot-ext/fs/bootfs/fakeroot
MKIMAGE_BIN = $(IMAGE_OUT_PATH)/../build/uboot/tools/mkimage


BOOTFS_LABEL = $(subst ",,$(BR2_TARGET_BOOTFS_LABEL))
BOOTFS_OPTS = \
	-d $(BOOTFS_DIR) \
	-r 1 \
	-L "$(BOOTFS_LABEL)" \
	-I 256


define BOOTFS_GEN

	@echo -e "\n"
	@echo "start to make bootfs ..............................."
	echo "#!/bin/sh" > $(FAKE_ROOT_FILE)
	echo "set -e" >> $(FAKE_ROOT_FILE)
	echo "rm -rf $(BOOTFS_DIR)" >> $(FAKE_ROOT_FILE)
	echo "mkdir -p $(BOOTFS_DIR)" >> $(FAKE_ROOT_FILE) 

	echo "cp -f $(UENV_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)

	echo "cp -f $(KERNEL_IMAGE_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(KERNEL_DTB_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(INITRAMFS_FILE) $(BOOTFS_DIR)/initramfs-generic.img" >> $(FAKE_ROOT_FILE)

	echo "rm -f $(BOOTFS_IMG)" >> $(FAKE_ROOT_FILE)
	@chmod 777 $(FAKE_ROOT_FILE)
	echo "$(HOST_DIR)/sbin/mkfs.ext4 $(BOOTFS_OPTS) $(BOOTFS_IMG) $(BOOTFS_SIZE) \
	|| { ret=$$?; \
		echo "*** Maybe you need to increase the bootfs filesystem size BR2_TARGET_BOOTFS_SIZE" 1>&2; \
		exit $$ret; \
	} " >> $(FAKE_ROOT_FILE)
	
	FAKEROOTDONTTRYCHOWN=1 $(HOST_DIR)/bin/fakeroot -- $(FAKE_ROOT_FILE)
	@echo "make bootfs success..............................."
	@echo -e "\n"

endef

#when rootfs-cpio done, generate bootfs img
ROOTFS_CPIO_POST_GEN_HOOKS += BOOTFS_GEN

################################################################################
#
# integrate initrd and kernel into boot image with fat32 filesystem.
#
################################################################################

# get bootfs size from partitions json file
BOOTFS_SIZE = $$($(HOST_DIR)/bin/jq '.partitions[] | select(.name == "bootfs") | .size' $(BR2_PACKAGE_PARTITIONS))

#rootfs-cpio depend on linux
BOOTFS_DEPENDENCIES = rootfs-cpio host-e2fsprogs

IMAGE_OUT_PATH = $(patsubst %/,%,$(dir $(@)))
BOOTFS_DIR = $(IMAGE_OUT_PATH)/bootfs
BOOTFS_IMG = $(IMAGE_OUT_PATH)/bootfs.img
KERNEL_IMAGE_FILE = $(IMAGE_OUT_PATH)/Image

KERNEL_DTB := $(subst ",,$(BR2_LINUX_KERNEL_INTREE_DTS_NAME))
KERNEL_DTB_NAME = $(patsubst %,%,$(notdir $(KERNEL_DTB))).dtb
KERNEL_DTB_FILE = $(IMAGE_OUT_PATH)/$(KERNEL_DTB_NAME)
UENV_BIN_FILE = $(IMAGE_OUT_PATH)/uboot-env.bin

INITRAMFS_FILE = $@$(ROOTFS_CPIO_COMPRESS_EXT)
FAKE_ROOT_FILE = ../buildroot-ext/fs/bootfs/fakeroot
BOOTFS_LABEL = $(subst ",,$(BR2_TARGET_BOOTFS_LABEL))
BOOTFS_EXT4_OPTS = \
	-d $(BOOTFS_DIR) \
	-r 1 \
	-L "$(BOOTFS_LABEL)" \
	-I 256

ifdef BR2_TARGET_BOOTFS_TYPE_EXT4

define BOOTFS_GEN

	@echo -e "\n"
	@echo "start to make bootfs ..............................."

	echo "#!/bin/sh" > $(FAKE_ROOT_FILE)
	echo "set -e" >> $(FAKE_ROOT_FILE)
	echo "rm -rf $(BOOTFS_DIR)" >> $(FAKE_ROOT_FILE)
	echo "mkdir -p $(BOOTFS_DIR)" >> $(FAKE_ROOT_FILE) 

	echo "cp -f $(UENV_BIN_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(KERNEL_IMAGE_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(KERNEL_DTB_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(INITRAMFS_FILE) $(BOOTFS_DIR)/initramfs-generic.img" >> $(FAKE_ROOT_FILE)

	echo "rm -f $(BOOTFS_IMG)" >> $(FAKE_ROOT_FILE)
	echo "$(HOST_DIR)/sbin/mkfs.ext4 $(BOOTFS_EXT4_OPTS) $(BOOTFS_IMG) $(BOOTFS_SIZE) \
	|| { ret=$$?; \
		echo "*** Maybe you need to increase the bootfs filesystem size BR2_TARGET_BOOTFS_SIZE" 1>&2; \
		exit $$ret; \
	} " >> $(FAKE_ROOT_FILE)
		
	@chmod 777 $(FAKE_ROOT_FILE)
	FAKEROOTDONTTRYCHOWN=1 $(HOST_DIR)/bin/fakeroot -- $(FAKE_ROOT_FILE)
	@echo "make bootfs success..............................."
	@echo -e "\n"

endef
else

define BOOTFS_GEN
	@echo -e "\n"
	@echo "start to make bootfs ..............................."

	echo "#!/bin/sh" > $(FAKE_ROOT_FILE)
	echo "set -e" >> $(FAKE_ROOT_FILE)
	echo "rm -rf $(BOOTFS_DIR)" >> $(FAKE_ROOT_FILE)
	echo "mkdir -p $(BOOTFS_DIR)" >> $(FAKE_ROOT_FILE) 

	echo "rm -f $(BOOTFS_IMG)" >> $(FAKE_ROOT_FILE)
	echo "dd if=/dev/zero of=$(BOOTFS_IMG) count=1 bs=$(BOOTFS_SIZE)" >> $(FAKE_ROOT_FILE)
	echo "mkfs.vfat $(BOOTFS_IMG)" >> $(FAKE_ROOT_FILE)
	
	echo "cp -f $(UENV_BIN_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(KERNEL_IMAGE_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(KERNEL_DTB_FILE) $(BOOTFS_DIR)/ " >> $(FAKE_ROOT_FILE)
	echo "cp -f $(INITRAMFS_FILE) $(BOOTFS_DIR)/initramfs-generic.img" >> $(FAKE_ROOT_FILE)
	echo "mcopy -i $(BOOTFS_IMG) $(BOOTFS_DIR)/* ::" >> $(FAKE_ROOT_FILE)

	@chmod 777 $(FAKE_ROOT_FILE)
	FAKEROOTDONTTRYCHOWN=1 $(HOST_DIR)/bin/fakeroot -- $(FAKE_ROOT_FILE)
	@echo "make bootfs success..............................."
	@echo -e "\n"

endef
endif

#when rootfs-cpio done, generate bootfs img
ROOTFS_CPIO_POST_GEN_HOOKS += BOOTFS_GEN

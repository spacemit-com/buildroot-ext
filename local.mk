#for dev purpose , lists pkg-source dir here and buildroot use it priority
#为了方便源码开发，这里提供各模块源码路径覆写，buildroot优先使用

#e.g example
#XXX is package name defined in buildroot
#XXX_OVERRIDE_SRCDIR = /path/to/xxx/dir
#XXX_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS = --exclude unittests --exclude test.txt  --include .git

# please config linux dir in menuconfig
# LINUX_OVERRIDE_SRCDIR = $(TOPDIR)/../bsp-src/linux-6.1

# Make BR2_LINUX_KERNEL_PATCH work with BR2_LINUX_KERNEL_CUSTOM_DIR
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_DIR),y)
ifneq ($(call qstrip,$(BR2_LINUX_KERNEL_PATCH)),)

define LINUX_APPLY_CUSTOM_DIR_PATCHES
	@for p in $(call qstrip,$(BR2_LINUX_KERNEL_PATCH)) ; do \
		[ -d "$$p" ] || continue ; \
		for f in $$p/*.patch ; do \
			[ -f "$$f" ] || continue ; \
			patch -p1 -N -d $(@D) < "$$f" 2>/dev/null || true ; \
		done; \
	done
endef

LINUX_POST_RSYNC_HOOKS += LINUX_APPLY_CUSTOM_DIR_PATCHES

endif
endif

UBOOT_OVERRIDE_SRCDIR = $(TOPDIR)/../bsp-src/uboot-2022.10
OPENSBI_OVERRIDE_SRCDIR = $(TOPDIR)/../bsp-src/opensbi
MESA3D_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/mesa
IMG_GPU_POWERVR_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/img-gpu-powervr
GLMARK2_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/glmark2
FACTORYTEST_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/factorytest

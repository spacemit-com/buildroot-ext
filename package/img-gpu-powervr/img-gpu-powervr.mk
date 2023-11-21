IMG_GPU_POWERVR_VERSION:=23.2.6460340
IMG_GPU_POWERVR_SITE=$(TOPDIR)/../buildroot-ext/patches/img-gpu-powervr
IMG_GPU_POWERVR_SITE_METHOD=file
IMG_GPU_POWERVR_SOURCE=img-gpu-powervr-bin-$(IMG_GPU_POWERVR_VERSION).tar.xz

IMG_GPU_POWERVR_INSTALL_STAGING = YES

IMG_GPU_POWERVR_LICENSE = Strictly Confidential
IMG_GPU_POWERVR_REDISTRIBUTE = NO

IMG_GPU_POWERVR_PROVIDES = libgles libopencl
IMG_GPU_POWERVR_LIB_TARGET = $(call qstrip,$(BR2_PACKAGE_IMG_GPU_POWERVR_OUTPUT))

ifeq ($(IMG_GPU_POWERVR_LIB_TARGET),x11)
IMG_GPU_POWERVR_DEPENDENCIES += xlib_libXdamage xlib_libXext xlib_libXfixes
endif

ifneq ($(IMG_GPU_POWERVR_LIB_TARGET)$(BR2_riscv),fby)
IMG_GPU_POWERVR_DEPENDENCIES += libdrm
endif

ifeq ($(IMG_GPU_POWERVR_LIB_TARGET),wayland)
IMG_GPU_POWERVR_DEPENDENCIES += wayland
endif

define IMG_GPU_POWERVR_INSTALL_STAGING_CMDS
        cp -rdpf $(@D)/staging/usr/lib/glesv2.pc $(STAGING_DIR)/usr/lib/pkgconfig/
        cp -rdpf $(@D)/staging/include/* $(STAGING_DIR)/usr/include/
        cp -rdpf $(@D)/staging/usr/lib/* $(STAGING_DIR)/usr/lib/
endef

define IMG_GPU_POWERVR_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/local/share/pvr/shaders/
	cp -rdpf $(@D)/target/usr/local/share/pvr/shaders/* $(TARGET_DIR)/usr/local/share/pvr/shaders/
	cp -rdpf $(@D)/target/lib/* $(TARGET_DIR)/lib/
	cp -rdpf $(@D)/target/usr/* $(TARGET_DIR)/usr/
endef

$(eval $(generic-package))

MPP_VERSION := 0.0.57
MPP_SITE = $(TOPDIR)/../package-src/mpp
MPP_SITE_METHOD = local
MPP_SUPPORTS_IN_SOURCE_BUILD = NO
MPP_INSTALL_STAGING = YES
MPP_DEPENDENCIES = sdl2

# default CMAKE_INSTALL_PREFIX is $(TARGET_DIR)/usr, change to below
# note: not have -DCROSS_COMPILE
MPP_CONF_OPTS = -DRUN_PLATFORM="RISCV" \
			-DCI_LOG_LEVEL=4 \
			-DARCH_RISCV="Y" \
			-DCMAKE_INSTALL_PREFIX="/usr" \

define MPP_INSTALL_STAGING_CMDS
	cp -rdpf $(@D)/include/* $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/mpi/include/* $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/utils/include/* $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/al/include/* $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/buildroot-build/mpi/libspacemit_mpp.so* $(STAGING_DIR)/usr/lib/
	cp -rdpf $(@D)/buildroot-build/spacemit_mpp.pc $(STAGING_DIR)/usr/lib/pkgconfig/
endef

$(eval $(cmake-package))

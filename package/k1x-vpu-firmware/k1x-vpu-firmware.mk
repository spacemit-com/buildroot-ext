K1X_VPU_FIRMWARE_VERSION:=1.0.0
K1X_VPU_FIRMWARE_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k1x-vpu-firmware
K1X_VPU_FIRMWARE_SITE_METHOD = local

define K1X_VPU_FIRMWARE_INSTALL_TARGET_CMDS
	cp -rdpf $(@D)/lib/* $(TARGET_DIR)/lib/
endef

$(eval $(generic-package))


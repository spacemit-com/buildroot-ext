K3X_VPU_FIRMWARE_VERSION:=0.0.2
K3X_VPU_FIRMWARE_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k3x-vpu-firmware
K3X_VPU_FIRMWARE_SITE_METHOD = local

define K3X_VPU_FIRMWARE_INSTALL_TARGET_CMDS
	cp -rdpf $(@D)/lib/* $(TARGET_DIR)/lib/
endef

$(eval $(generic-package))


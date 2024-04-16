ONNX_RUNTIME_VERSION:=1.0.11
ONNX_RUNTIME_SITE=http://archive.spacemit.com/buildroot/dl/onnx-runtime
ONNX_RUNTIME_SITE_METHOD=wget
ONNX_RUNTIME_SOURCE=spacemit-ort.riscv64.$(ONNX_RUNTIME_VERSION).tar.gz

ONNX_RUNTIME_INSTALL_STAGING = YES


define ONNX_RUNTIME_INSTALL_STAGING_CMDS
        cp -rdpf $(@D)/include/* $(STAGING_DIR)/usr/include/
        cp -rdpf $(@D)/lib/* $(STAGING_DIR)/usr/lib/
endef

define ONNX_RUNTIME_INSTALL_TARGET_CMDS
	cp -rdpf $(@D)/lib/* $(TARGET_DIR)/usr/lib/
	cp -rdpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))

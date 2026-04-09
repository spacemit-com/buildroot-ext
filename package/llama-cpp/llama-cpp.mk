LLAMA_CPP_VERSION:=0.0.6
LLAMA_CPP_SITE=http://archive.spacemit.com/spacemit-ai/llama.cpp
LLAMA_CPP_SITE_METHOD=wget
LLAMA_CPP_SOURCE=spacemit-llama.cpp.riscv64.$(LLAMA_CPP_VERSION).tar.gz

LLAMA_CPP_INSTALL_STAGING = YES


define LLAMA_CPP_INSTALL_STAGING_CMDS
	cp -rdpf $(@D)/include/* $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/lib/* $(STAGING_DIR)/usr/lib/
endef

define LLAMA_CPP_INSTALL_TARGET_CMDS
	cp -rdpf $(@D)/lib/* $(TARGET_DIR)/usr/lib/
	cp -rdpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))

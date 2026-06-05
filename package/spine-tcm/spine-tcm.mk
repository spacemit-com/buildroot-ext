SPINE_TCM_VERSION:=0.2.1
SPINE_TCM_SITE=https://archive.spacemit.com/spacemit-ai/tcm
SPINE_TCM_SITE_METHOD=wget
SPINE_TCM_SOURCE=spine-tcm-$(SPINE_TCM_VERSION).tar.gz

SPINE_TCM_INSTALL_STAGING = YES


define SPINE_TCM_INSTALL_STAGING_CMDS
	cp -rdpf $(@D)/include/* $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/lib/* $(STAGING_DIR)/usr/lib/
endef

define SPINE_TCM_INSTALL_TARGET_CMDS
	cp -rdpf $(@D)/lib/* $(TARGET_DIR)/usr/lib/
	cp -rdpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))

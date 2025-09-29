JDK_VERSION:=1.0.0
JDK_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/jdk
JDK_SITE_METHOD = local
JDK_DEPENDENCIES += mpp
JDK_INSTALL_TARGET = YES
JDK_INSTALL_STAGING = YES

define JDK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/lib/* $(STAGING_DIR)/usr/lib/
endef

define JDK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define JDK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/lib/* $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))

################################################################################
#
# HELLOWORLD
#
################################################################################

HELLOWORLD_SITE = $(BR2_EXTERNAL_k1_PATH)/../package-src/test
HELLOWORLD_SITE_METHOD = local
HELLOWORLD_INSTALL_TARGET = YES

define HELLOWORLD_BUILD_CMDS
	(cd $(@D);$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" -C $(@D) all;)
endef


define HELLOWORLD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/test $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

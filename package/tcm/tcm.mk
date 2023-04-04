################################################################################
#
# tcm
#
################################################################################

TCM_SITE = $(BR2_EXTERNAL_k1_PATH)/../package-src/tcm
TCM_SITE_METHOD = local
TCM_INSTALL_TARGET = YES

define TCM_BUILD_CMDS
	(cd $(@D);$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" -C $(@D) all;)
endef


define TCM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/app.elf $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

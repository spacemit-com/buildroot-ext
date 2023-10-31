################################################################################
#
# POSTMARK
#
################################################################################

FHOURSTONES88_VERSION = 82a4c71e1972b33db1431d28f79cd23b0a8d884c
FHOURSTONES88_SITE = https://github.com/tromp/fhourstones88.git
FHOURSTONES88_SITE_METHOD=git
FHOURSTONES88_INSTALL_STAGING = YES
FHOURSTONES88_INSTALL_TARGET = YES
CPPFLAGS=$(TARGET_CPPFLAGS) -xc++ -lstdc++ -shared-libgcc

define FHOURSTONES88_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(CPPFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) C488
endef

define FHOURSTONES88_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/book88 $(STAGING_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/C488 $(STAGING_DIR)/usr/bin
endef

define FHOURSTONES88_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/book88 $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/C488 $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

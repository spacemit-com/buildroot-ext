################################################################################
#
# tscp
#
################################################################################

TSCP_VERSION = c3c6b878d500b442bedcab42fdf85aa9e21fc194
TSCP_SITE = https://github.com/terredeciels/TSCP.git
TSCP_SITE_METHOD = git
TSCP_LICENSE = copyright

TSCP_INSTALL_TARGET = YES

define TSCP_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D) all

endef

define TSCP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tscp $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

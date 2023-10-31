################################################################################
#
# SWETEST
#
################################################################################

SWETEST_VERSION = b7c1e1bd2acd0597926f0e0071724beae1e39587
SWETEST_SITE = https://github.com/kunjara/swetest
SWETEST_SITE_METHOD = git
#SWETEST_INSTALL_STAGING = YES
SWETEST_INSTALL_TARGET = YES

define SWETEST_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/src swetest
endef

define SWETEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/swetest $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

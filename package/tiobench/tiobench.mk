################################################################################
#
# tiobench
#
################################################################################

TIOBENCH_VERSION = f4265bb679eca5b961826ccbd6be5b008d3892d4
TIOBENCH_SITE = https://github.com/mkuoppal/tiobench.git
TIOBENCH_SITE_METHOD = git
TIOBENCH_INSTALL_TARGET = YES
TIOBENCH_LICENSE = GPLv2

define TIOBENCH_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D) all
endef

define TIOBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tiotest $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/test_largefiles $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/tiobench.pl $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

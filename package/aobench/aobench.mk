################################################################################
#
# aobench
#
################################################################################

AOBENCH_VERSION = bcf33576cf308a448fb600c4e3b98ba2b6348540
AOBENCH_SITE = https://github.com/syoyo/aobench.git
AOBENCH_SITE_METHOD = git
AOBENCH_LICENSE = GPLv2
AOBENCH_LDFLAGS = $(TARGET_LDFLAGS) -lm
AOBENCH_INSTALL_TARGET = YES

define AOBENCH_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(AOBENCH_LDFLAGS)\
		$(@D)/ao.c -o $(@D)/aobench
endef

define AOBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/aobench $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

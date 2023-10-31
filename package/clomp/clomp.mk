################################################################################
#
# CLOMP
#
################################################################################

CLOMP_VERSION = a9df4e8c48d5c717073b2f69c0fc5202f83821d5
CLOMP_SITE = https://github.com/sonjoyp/Clomp-Without-MP
CLOMP_SITE_METHOD = git
CLOMP_LICENSE = Copy right
#CLOMP_INSTALL_STAGING = YES
CLOMP_INSTALL_TARGET = YES

define CLOMP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(CFLAGS) -O3 $(@D)/clomp.c -o $(@D)/clomp $(TARGET_LDFLAGS) -lm  \
		
endef

define CLOMP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/clomp $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

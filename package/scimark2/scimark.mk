################################################################################
#
# SCIMARK2
#
################################################################################

SCIMARK2_VERSION = 162df22263dba31c9e186805d413f0b5216ab510
SCIMARK2_SITE = https://gitee.com/spacemit/scimark2.git
SCIMARK2_SITE_METHOD = git
#SCIMARK2_INSTALL_STAGING = YES
SCIMARK2_INSTALL_TARGET = YES

define SCIMARK2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/c all
endef

define SCIMARK2_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/c/scimark4 $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

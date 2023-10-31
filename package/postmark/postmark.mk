################################################################################
#
# POSTMARK
#
################################################################################

POSTMARK_VERSION = 58c66bde1e79ccf68f7ac2348ca4cb1259dda1cf
POSTMARK_SITE = https://gitee.com/spacemit/postmark.git
POSTMARK_SITE_METHOD=git
POSTMARK_LICENSE = LGPL-2.1
#POSTMARK_LICENSE_FILES = COPYING
#POSTMARK_CPE_ID_VENDOR = POSTMARK_project
POSTMARK_INSTALL_STAGING = YES
POSTMARK_INSTALL_TARGET = YES

define POSTMARK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef

define POSTMARK_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX=$(STAGING_DIR)/usr -C $(@D) install
	$(INSTALL) -D -m 0755 $(@D)/postmark $(STAGING_DIR)/usr/bin
endef

define POSTMARK_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX=$(TARGET_DIR)/usr -C $(@D) install
	$(INSTALL) -D -m 0755 $(@D)/postmark $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

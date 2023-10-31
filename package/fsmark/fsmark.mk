################################################################################
#
# fs_mark
#
################################################################################

FSMARK_VERSION = 2628be58146de63a13260ff64550f84275556c0e
FSMARK_SITE = https://github.com/josefbacik/fs_mark.git
FSMARK_SITE_METHOD = git
FSMARK_INSTALL_TARGET = YES
FSMARK_LICENSE = GPLv2

define FSMARK_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D) all
endef

define FSMARK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fs_mark $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

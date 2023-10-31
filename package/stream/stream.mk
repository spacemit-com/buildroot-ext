################################################################################
#
# stream
#
################################################################################

STREAM_VERSION=44f4e124051170b737c2692fb57db9ba9731a0c2
STREAM_SITE=https://gitee.com/spacemit/STREAM
STREAM_SITE_METHOD=git

define STREAM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define STREAM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/stream $(TARGET_DIR)/usr/bin/stream
endef

$(eval $(generic-package))
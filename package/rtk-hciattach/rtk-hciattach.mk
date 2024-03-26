################################################################################
#
# rtk hciattach
#
################################################################################

RTK_HCIATTACH_VERSION = 1.0.0
RTK_HCIATTACH_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/rtk_hciattach
RTK_HCIATTACH_SITE_METHOD = local

define RTK_HCIATTACH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) rtk_hciattach
endef

define RTK_HCIATTACH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/rtk_hciattach $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))

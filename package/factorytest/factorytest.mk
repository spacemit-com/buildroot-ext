FACTORYTEST_VERSION = 1.0
FACTORYTEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/factorytest
FACTORYTEST_SITE = local

define FACTORYTEST_INSTALL_TARGET_CMDS
	cp -r $(@D) $(TARGET_DIR)/opt/factorytest
endef

$(eval $(generic-package))

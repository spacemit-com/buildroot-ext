FACTORYTEST_VERSION = 1.0
FACTORYTEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/factorytest
FACTORYTEST_SITE = local

define FACTORYTEST_INSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/opt/factorytest
	mkdir -p $(TARGET_DIR)/opt/factorytest
	cp -r $(@D)/cricket $(TARGET_DIR)/opt/factorytest
	cp -r $(@D)/res $(TARGET_DIR)/opt/factorytest
	cp -r $(@D)/tests $(TARGET_DIR)/opt/factorytest
	cp -r $(@D)/utils $(TARGET_DIR)/opt/factorytest
	cp $(@D)/gui-main $(TARGET_DIR)/opt/factorytest
	cp $(@D)/stability $(TARGET_DIR)/opt/factorytest
	cp $(@D)/memtester.sh $(TARGET_DIR)/opt/factorytest
	cp $(@D)/stress-ng.sh $(TARGET_DIR)/opt/factorytest
endef

$(eval $(generic-package))

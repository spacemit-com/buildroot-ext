V2D_TEST_VERSION:=1.0.0
V2D_TEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/v2d-test
V2D_TEST_SITE_METHOD = local
V2D_TEST_INSTALL_TARGET = YES

define V2D_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/v2d_test $(TARGET_DIR)/usr/bin/v2d_test
	$(INSTALL) -D -m 0755 $(@D)/libv2d.so $(TARGET_DIR)/usr/lib/libv2d.so
	$(INSTALL) -D -m 0755 $(@D)/libdmabufheap.so $(TARGET_DIR)/usr/lib/libdmabufheap.so
endef

$(eval $(cmake-package))
DRM_TEST_VERSION:=1.0.0
DRM_TEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/drm-test
DRM_TEST_SITE_METHOD = local
DRM_TEST_INSTALL_TARGET = YES

define DRM_TEST_BUILD_CMDS
	($(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" -C $(@D) all;)
endef

define DRM_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/modeset-single-buffer $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/modeset-double-buffer $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/modeset-vsync $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/modeset-atomic $(TARGET_DIR)/usr/bin/

endef

DRM_TEST_DEPENDENCIES = libdrm
$(eval $(generic-package))

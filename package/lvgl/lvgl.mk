LVGL_VERSION:=9.2.2
LVGL_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/lv_port_linux
LVGL_SITE_METHOD = local
LVGL_INSTALL_TARGET = YES
LVGL_INSTALL_STAGING = YES

LVGL_DEPENDENCIES = libdrm
#define LVGL_BUILD_CMDS
#	($(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" -C $(@D) all;)
#endef

define LVGL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/main $(TARGET_DIR)/usr/bin/lvgl_main
	cp -a $(@D)/lib/* $(TARGET_DIR)/usr/lib/
endef
$(eval $(cmake-package))

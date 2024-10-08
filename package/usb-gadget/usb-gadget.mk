USB_GADGET_VERSION:=0.5.0
USB_GADGET_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/usb-gadget
USB_GADGET_SITE_METHOD = local
USB_GADGET_INSTALL_TARGET = YES

define USB_GADGET_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define USB_GADGET_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/uvc-gadget-new $(TARGET_DIR)/usr/bin/uvc-gadget-new
	$(INSTALL) -D -m 0755 $(@D)/scripts/gadget-setup.sh $(TARGET_DIR)/usr/bin/gadget-setup.sh
	$(INSTALL) -D -m 0755 $(@D)/scripts/uvc-gadget-setup.sh $(TARGET_DIR)/usr/bin/uvc-gadget-setup.sh

endef

$(eval $(generic-package))


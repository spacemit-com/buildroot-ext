################################################################################
#
# oabenchv2
#
################################################################################

OABENCHV2_VERSION = 7fb9a2835ed59675f6f5b2c5553a55b8322dc5b9
OABENCHV2_SITE = https://gitee.com/spacemit/oabenchv2.git
OABENCHV2_SITE_METHOD = git

OABENCHV2_INSTALL_TARGET = YES

define OABENCHV2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) distclean
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef


define OABENCHV2_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/oabenchv2

	$(INSTALL) -D -m 0755 $(@D)/util/bin/cheader $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/util/bin/psnr $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/util/bin/swap $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/util/bin/tiffcmp $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/util/bin/uudecode $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/util/bin/uuencode $(TARGET_DIR)/usr/bin/oabenchv2

	$(INSTALL) -D -m 0755 $(@D)/oav2/gcc/bin_lite/bezierv2fixed_lite $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/oav2/gcc/bin_lite/bezierv2float_lite $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/oav2/gcc/bin_lite/ditherv2_lite $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/oav2/gcc/bin_lite/empty_lite $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/oav2/gcc/bin_lite/rotatev2_lite $(TARGET_DIR)/usr/bin/oabenchv2
	$(INSTALL) -D -m 0755 $(@D)/oav2/gcc/bin_lite/textv2_lite $(TARGET_DIR)/usr/bin/oabenchv2


endef

$(eval $(generic-package))

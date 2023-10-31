################################################################################
#
# dcraw
#
################################################################################

DCRAW_VERSION = c1a4cb9707105c9cb4cb687fd671992300e6db01
DCRAW_SITE = https://github.com/6by9/dcraw.git
DCRAW_SITE_METHOD = git
DCRAW_LICENSE = GPLv2
DCRAW_DEPENDENCIES = jasper jpeg lcms2
DCRAW_LDFLAGS = $(TARGET_LDFLAGS) -lm -ljasper -ljpeg -llcms2 -DNODEPS
DCRAW_INSTALL_TARGET = YES

define DCRAW_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(DCRAW_LDFLAGS)\
		$(@D)/dcraw.c -o $(@D)/dcraw
endef

define DCRAW_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/dcraw $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

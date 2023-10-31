################################################################################
#
# cray
#
################################################################################

CRAY_VERSION = 7feeb564668f23582f161376b3aa0f1761655550
CRAY_SITE = https://github.com/vkoskiv/c-ray.git
CRAY_SITE_METHOD = git
CRAY_INSTALL_TARGET = YES
CRAY_CONF_OPTS = -DBUILD_TESTING=ON \
	-DBUILD_TEST=ON \
	-DBUILD_TESTS=ON

# TODO enable SDL2######

define CRAY_BUILD_CMDS
	(cd $(@D); ./rebuild/testing-on;)
endef


define CRAY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/c-ray $(TARGET_DIR)/usr/bin

endef

#$(eval $(generic-package))
$(eval $(cmake-package))

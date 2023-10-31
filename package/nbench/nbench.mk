################################################################################
#
# nbench
#
################################################################################

NBENCH_VERSION = c7be4584daffba650c889e31d3fff7b0d9e872ca
NBENCH_SITE = https://gitee.com/spacemit/nbench
NBENCH_SITE_METHOD = git

define NBENCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D)
endef

define NBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/nbench $(TARGET_DIR)/usr/bin/nbench
endef

$(eval $(generic-package))
################################################################################
#
# XSBENCH
#
################################################################################

XSBENCH_VERSION = 6e2beb7d8eb8edbf901bc6cf56d9f6a40444fe78
XSBENCH_SITE = https://github.com/ANL-CESAR/XSBench.git
XSBENCH_SITE_METHOD = git
XSBENCH_LICENSE = MIT
XSBENCH_INSTALL_TARGET = YES

define XSBENCH_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/openmp-threading XSBench
endef


define XSBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/openmp-threading/XSBench $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

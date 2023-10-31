################################################################################
#
# telebench
#
################################################################################

TELEBENCH_VERSION = ae6fc3399e1d705b157f5926aa3c4cee5f53a52b
TELEBENCH_SITE = https://github.com/eembc/telebench.git
TELEBENCH_SITE_METHOD = git

TELEBENCH_INSTALL_TARGET = YES

define TELEBENCH_BUILD_CMDS
	rm $(@D)/util/make/vc.mak
	rm $(@D)/util/make/vcvars32.bat

	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef


define TELEBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/telebench
	cp -rf $(@D)/telecom/gcc/bin $(TARGET_DIR)/usr/bin/telebench/
	cp -rf $(@D)/telecom/gcc/bin_lite $(TARGET_DIR)/usr/bin/telebench/
	
endef

$(eval $(generic-package))

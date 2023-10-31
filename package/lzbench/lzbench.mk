################################################################################
#
# lzbench
#
################################################################################

LZBENCH_VERSION = 609d783118ca6026aa0d1bab7e485a62b6c7e4f0
LZBENCH_SITE = https://github.com/inikep/lzbench.git
LZBENCH_SITE_METHOD=git
LZBENCH_INSTALL_TARGET = YES
TARGET_CXXFLAGS += -fpermissive

define LZBENCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		CXX="$(TARGET_CXX) $(TARGET_CXXFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)
endef


define LZBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/lzbench $(TARGET_DIR)/usr/bin

endef

$(eval $(generic-package))

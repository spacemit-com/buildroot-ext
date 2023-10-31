################################################################################
#
# linpack
#
################################################################################

LINPACK_SOURCE=linpack_bench.c
LINPACK_SITE=https://people.sc.fsu.edu/~jburkardt/c_src/linpack_bench

define LINPACK_EXTRACT_CMDS
	cp $(LINPACK_DL_DIR)/$($(PKG)_SOURCE) $(@D)/
endef

define LINPACK_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) LDLIBS="-lm" -C $(@D) linpack_bench
endef

define LINPACK_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/linpack_bench $(TARGET_DIR)/usr/bin/linpack_bench
endef

$(eval $(generic-package))
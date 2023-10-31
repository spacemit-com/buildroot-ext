################################################################################
#
# sysbench
#
################################################################################

# Not work on RV currently
# FIXME

SYSBENCH_VERSION=1.0.20
SYSBENCH_SOURCE=$(SYSBENCH_VERSION).tar.gz
SYSBENCH_SITE=https://github.com/akopytov/sysbench/archive/refs/tags

SYSBENCH_CONF_OPTS = \
	--host=riscv64-buildroot-linux-gnu \
	--without-mysql \
	--with-system-ck

define SYSBENCH_CONFIGURE_CMDS
	(cd $(@D); ./autogen.sh && \
		CC="riscv64-unknown-linux-gnu-gcc" \
		CK_CFLAGS="-I $(TARGET_DIR)/usr/local/include" \
		CK_LIBS="-L $(TARGET_DIR)/usr/local/lib" \
		./configure $(SYSBENCH_CONF_OPTS))
endef

$(eval $(autotools-package))
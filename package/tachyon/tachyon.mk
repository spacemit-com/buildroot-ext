################################################################################
#
# TAVHYON
#
################################################################################

TACHYON_VERSION = 4e347495c3d996ed5f68d96a424d481d030843da
TACHYON_SITE = https://gitee.com/spacemit/Tachyon.git
TACHYON_SITE_METHOD = git
TACHYON_INSTALL_TARGET = YES

TACHYON_CFLAGS = $(TARGET_CFLAGS) -Wall -ffast-math -DLinux

define TACHYON_BUILD_CMDS
	(cd $(@D)/unix; $(TARGET_MAKE_ENV) $(MAKE1) CC=$(TARGET_CC) linux-riscv64 ;)

endef


define TACHYON_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/compile/linux-riscv64/tachyon $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

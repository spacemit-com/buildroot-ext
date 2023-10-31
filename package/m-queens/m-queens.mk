################################################################################
#
# m-queens
#
################################################################################

M_QUEENS_VERSION = 93a53fe066766735a1251160d4dbb843a7b33203
M_QUEENS_SITE = https://github.com/sudden6/m-queens.git
M_QUEENS_SITE_METHOD = git
M_QUEENS_LICENSE = GPLGPL-3.0 license
M_QUEENS_CFLAGS = $(TARGET_CFLAGS) -O2 -std=c99 -fopenmp
M_QUEENS_INSTALL_TARGET = YES

define M_QUEENS_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)\
		$(@D)/main.c -o $(@D)/m-queens
	
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(M_QUEENS_CFLAGS) $(TARGET_LDFLAGS)\
		$(@D)/main.c -o $(@D)/m-queens-openmp
endef

define M_QUEENS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/m-queens $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/m-queens-openmp $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

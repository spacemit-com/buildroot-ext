################################################################################
#
# HIMENO
#
################################################################################

HIMENO_VERSION = 8ad572264236fd3ce9977f64517316c0480bce15
HIMENO_SITE = https://github.com/calorie/himeno_benchmark.git
HIMENO_SITE_METHOD = git
HIMENO_DEPENDENCIES = openmpi
HIMENO_INSTALL_TARGET = YES
HIMENO_LDFLAGS += $(TARGET_LDFLAGS) -lmpi

define HIMENO_BUILD_CMDS
	$(TARGET_MAKE_ENV) cp $(@D)/Makefile.sample $(@D)/Makefile
	(cd $(@D);$(TARGET_MAKE_ENV) $(@D)/paramset.sh M 1 1 2;)
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(HIMENO_LDFLAGS)" \
		-C $(@D) all
endef

define HIMENO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bmt $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

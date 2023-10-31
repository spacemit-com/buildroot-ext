################################################################################
#
# aom-av1-psy
#
################################################################################

AOM_AV1_PSY_VERSION = 33d1bd19ff594144b75f6ca5eb764fc8c1dffc74
AOM_AV1_PSY_SITE = https://github.com/BlueSwordM/aom-av1-psy.git
AOM_AV1_PSY_SITE_METHOD = git
AOM_AV1_PSY_LICENSE = BSD 2-Clause
AOM_AV1_PSY_INSTALL_TARGET = YES
AOM_AV1_PSY_BUILDDIR = $(@D)/../aom-av1-psy_build

define AOM_AV1_PSY_BUILD_CMDS
	rm -rf $(AOM_AV1_PSY_BUILDDIR)
  	mkdir -p $(AOM_AV1_PSY_BUILDDIR)
	rm -f $(@D)/CMakeCache.txt $(@D)/CMakeFiles
	
	(cd $(AOM_AV1_PSY_BUILDDIR);$(TARGET_MAKE_ENV) cmake $(@D) \
 	-G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="$(HOST_DIR)/share/buildroot/toolchainfile.cmake" \
 	-DCMAKE_INSTALL_PREFIX="./usr" -DCMAKE_INSTALL_RUNSTATEDIR="/run" -DCMAKE_COLOR_MAKEFILE=OFF \
 	-DBUILD_DOC=OFF -DBUILD_DOCS=OFF -DBUILD_EXAMPLE=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TEST=OFF \
 	-DBUILD_TESTS=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON;$(MAKE) all;	$(MAKE) install)

endef

define AOM_AV1_PSY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(AOM_AV1_PSY_BUILDDIR)/usr/bin/aomdec $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(AOM_AV1_PSY_BUILDDIR)/usr/bin/aomenc $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(AOM_AV1_PSY_BUILDDIR)/usr/lib/libaom.so.3.5.0 $(TARGET_DIR)/usr/lib
	(cd $(TARGET_DIR)/usr/lib; ln -s libaom.so.3.5.0 libaom.so.3; ln -s libaom.so.3 libaom.so)

		
endef

$(eval $(generic-package))

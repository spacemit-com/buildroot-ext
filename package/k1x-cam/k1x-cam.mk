K1X_CAM_VERSION:=0.0.11
K1X_CAM_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k1x-cam
K1X_CAM_SITE_METHOD = local

K1X_CAM_CONF_OPTS = -DRUN_PLATFORM="RISCV" \
                        -DCI_LOG_LEVEL=4 \
                        -DARCH_RISCV="Y" \
                        -DCMAKE_INSTALL_PREFIX="/usr"

#define K1X_CAM_POST_RSYNC
#    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libcpp.so $(STAGING_DIR)/usr/lib/libcpp.so
#    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libcppfw-2.0.so $(STAGING_DIR)/usr/lib/libcppfw-2.0.so
#    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libisp.so $(STAGING_DIR)/usr/lib/libisp.so
#    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libispeagle.so $(STAGING_DIR)/usr/lib/libispeagle.so
#    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libtuningtools.so $(STAGING_DIR)/usr/lib/libtuningtools.so
#    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libvi.so $(STAGING_DIR)/usr/lib/libvi.so
#    $(INSTALL) -D -m 0644 $(@D)/sensors/libcam_sensors.so $(STAGING_DIR)/usr/lib/libcam_sensors.so
#endef
#K1X_CAM_POST_RSYNC_HOOKS += K1X_CAM_POST_RSYNC

ifeq ($(BR2_PACKAGE_K1X_CAM),y)
define K1X_CAM_POST_BUILD
	$(INSTALL) -D -m 0755 $(@D)/libs/lib64/libcpp.so $(STAGING_DIR)/usr/lib/libcpp.so
	$(INSTALL) -D -m 0755 $(@D)/libs/lib64/libcppfw-2.0.so $(STAGING_DIR)/usr/lib/libcppfw-2.0.so
	$(INSTALL) -D -m 0755 $(@D)/libs/lib64/libisp.so $(STAGING_DIR)/usr/lib/libisp.so
	$(INSTALL) -D -m 0755 $(@D)/libs/lib64/libispeagle.so $(STAGING_DIR)/usr/lib/libispeagle.so
	$(INSTALL) -D -m 0755 $(@D)/libs/lib64/libtuningtools.so $(STAGING_DIR)/usr/lib/libtuningtools.so
	$(INSTALL) -D -m 0755 $(@D)/libs/lib64/libvi.so $(STAGING_DIR)/usr/lib/libvi.so
	$(INSTALL) -D -m 0644 $(@D)/sensors/libcam_sensors.so $(STAGING_DIR)/usr/lib/libcam_sensors.so
	cp -rdpf $(@D)/demo/*.h $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/libs/include/*.h $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/sensors/include/*.h $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/demo/include/*.h $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/demo/include/dmabufheap/*.h $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/demo/utils/*.h $(STAGING_DIR)/usr/include/
	cp -rdpf $(@D)/demo/extern/*.h $(STAGING_DIR)/usr/include/
endef
K1X_CAM_POST_BUILD_HOOKS += K1X_CAM_POST_BUILD
endif

ifeq ($(BR2_PACKAGE_K1X_CAM_LIB),y)
define K1X_CAM_LIB_POST_BUILD
	$(INSTALL) -D -m 0644 $(@D)/demo/libsdkcam.so $(STAGING_DIR)/usr/lib/libsdkcam.so
	cp -rdpf $(@D)/k1x-cam.pc $(STAGING_DIR)/usr/lib/pkgconfig/
endef
K1X_CAM_POST_BUILD_HOOKS += K1X_CAM_LIB_POST_BUILD
endif

ifeq ($(BR2_PACKAGE_K1X_CAM_TEST),y)
define K1X_CAM_TEST_POST_BUILD
	$(INSTALL) -D -m 0644 $(@D)/demo/cam-test $(TARGET_DIR)/usr/bin/cam-test
endef
endif

$(eval $(cmake-package))

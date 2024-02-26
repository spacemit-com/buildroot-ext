K1X_CAM_VERSION:=1.0.0
K1X_CAM_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k1x-cam
K1X_CAM_SITE_METHOD = local

K1X_CAM_CONF_OPTS = -DRUN_PLATFORM="RISCV" \
                        -DCI_LOG_LEVEL=4 \
                        -DARCH_RISCV="Y" \
                        -DCMAKE_INSTALL_PREFIX="/usr" \

define K1X_CAM_POST_RSYNC
    $(INSTALL) -D -m 0644 $(@D)/libs/lib64/libcpp.so $(STAGING_DIR)/lib64/libcpp.so
    $(INSTALL) -D -m 0644 $(@D)/libs/lib64/libcppfw-2.0.so $(STAGING_DIR)/lib64/libcppfw-2.0.so
    $(INSTALL) -D -m 0644 $(@D)/libs/lib64/libisp.so $(STAGING_DIR)/lib64/libisp.so
    $(INSTALL) -D -m 0644 $(@D)/libs/lib64/libispeagle.so $(STAGING_DIR)/lib64/libispeagle.so
    $(INSTALL) -D -m 0644 $(@D)/libs/lib64/libtuningtools.so $(STAGING_DIR)/lib64/libtuningtools.so
    $(INSTALL) -D -m 0644 $(@D)/libs/lib64/libvi.so $(STAGING_DIR)/lib64/libvi.so
endef
K1X_CAM_POST_RSYNC_HOOKS += K1X_CAM_POST_RSYNC

define K1X_CAM_POST_BUILD
    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libcpp.so $(TARGET_DIR)/lib64/libcpp.so
    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libcppfw-2.0.so $(TARGET_DIR)/lib64/libcppfw-2.0.so
    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libisp.so $(TARGET_DIR)/lib64/libisp.so
    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libispeagle.so $(TARGET_DIR)/lib64/libispeagle.so
    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libtuningtools.so $(TARGET_DIR)/lib64/libtuningtools.so
    $(INSTALL) -D -m 0755 $(@D)/libs/lib64/libvi.so $(TARGET_DIR)/lib64/libvi.so
endef
K1X_CAM_POST_BUILD_HOOKS += K1X_CAM_POST_BUILD

$(eval $(cmake-package))

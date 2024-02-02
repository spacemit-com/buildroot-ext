AI_SUPPORT_VERSION:=1.0.4
AI_SUPPORT_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/ai-support
AI_SUPPORT_SITE_METHOD = local
AI_SUPPORT_DEPENDENCIES += onnx-runtime opencv4

# CMAKE_BUILD_TYPE is driven by BR2_ENABLE_RUNTIME_DEBUG
AI_SUPPORT_CONF_OPTS = -DTEST=OFF \
                       -DORT_HOME=$(STAGING_DIR)/usr

ifeq ($(BR2_PACKAGE_AI_SUPPORT_DEMO),y)
AI_SUPPORT_CONF_OPTS += -DDEMO=ON

define AI_SUPPORT_POST_BUILD
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/config
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/imgs
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/labels
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/models
    
    $(INSTALL) -D -m 0644 $(@D)/data/config/* $(TARGET_DIR)/usr/share/ai-support/config/
    $(INSTALL) -D -m 0644 $(@D)/data/imgs/* $(TARGET_DIR)/usr/share/ai-support/imgs/
    $(INSTALL) -D -m 0644 $(@D)/data/labels/* $(TARGET_DIR)/usr/share/ai-support/labels/
    $(INSTALL) -D -m 0644 $(@D)/rootfs/usr/share/models/* $(TARGET_DIR)/usr/share/ai-support/models/

endef
AI_SUPPORT_POST_BUILD_HOOKS += AI_SUPPORT_POST_BUILD

endif # BR2_PACKAGE_AI_SUPPORT_DEMO

$(eval $(cmake-package))

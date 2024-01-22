AI_SUPPORT_VERSION:=1.0.1
AI_SUPPORT_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/ai-support
AI_SUPPORT_SITE_METHOD = local
AI_SUPPORT_DEPENDENCIES += onnx-runtime

AI_SUPPORT_CONF_OPTS = -DCMAKE_BUILD_TYPE=Debug  \
                        -DTEST=OFF \
                        -DDEMO=ON \
                        -DORT_HOME=$(STAGING_DIR)/lib 

define AI_SUPPORT_POST_BUILD
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/config
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/imgs
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/labels
    mkdir -p $(TARGET_DIR)/usr/share/ai-support/models
    
    $(INSTALL) -D -m 0644 $(@D)/data/config/* $(TARGET_DIR)/usr/share/ai-support/config/
    $(INSTALL) -D -m 0644 $(@D)/data/imgs/* $(TARGET_DIR)/usr/share/ai-support/imgs/
    $(INSTALL) -D -m 0644 $(@D)/data/labels/* $(TARGET_DIR)/usr/share/ai-support/labels/
    $(INSTALL) -D -m 0644 $(@D)/share/models/* $(TARGET_DIR)/usr/share/ai-support/models/

endef
AI_SUPPORT_POST_BUILD_HOOKS += AI_SUPPORT_POST_BUILD


$(eval $(cmake-package))

AI_SUPPORT_VERSION:=1.0.1
AI_SUPPORT_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/ai-support
AI_SUPPORT_SITE_METHOD = local
AI_SUPPORT_DEPENDENCIES += onnx-runtime

AI_SUPPORT_CONF_OPTS = -DCMAKE_BUILD_TYPE=Debug  \
                        -DTEST=OFF \
                        -DDEMO=ON \
                        -DORT_HOME=$(STAGING_DIR)/lib 
                        


$(eval $(cmake-package))

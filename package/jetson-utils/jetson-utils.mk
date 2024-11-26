JETSON_UTILS_VERSION:=
JETSON_UTILS_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/jetson-utils
JETSON_UTILS_SITE_METHOD = local
#JETSON_UTILS_SITE = https://gitlab.dc.com:8443/bianbu/ai/jetson-utils
#JETSON_UTILS_SITE_METHOD = git

define JETSON_UTILS_BUILD_CMDS
        ($(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" -C $(@D) all;)
endef

$(eval $(cmake-package))

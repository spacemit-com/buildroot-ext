DRM_TEST_VERSION:=1.0.0
DRM_TEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/drm-test
DRM_TEST_SITE_METHOD = local
DRM_TEST_INSTALL_TARGET = YES

DRM_TEST_DEPENDENCIES = libdrm
$(eval $(cmake-package))

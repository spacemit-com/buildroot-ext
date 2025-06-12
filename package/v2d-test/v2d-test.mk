V2D_TEST_VERSION:=1.0.0
V2D_TEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/v2d-test
V2D_TEST_SITE_METHOD = local
V2D_TEST_INSTALL_TARGET = YES

$(eval $(cmake-package))
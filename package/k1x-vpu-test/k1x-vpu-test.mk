K1X_VPU_TEST_VERSION:=1.0.0
K1X_VPU_TEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k1x-vpu-test
K1X_VPU_TEST_SITE_METHOD = local

MPP_CONF_OPTS = -DRUN_PLATFORM="RISCV" \
                        -DCI_LOG_LEVEL=4 \
                        -DARCH_RISCV="Y" \
                        -DCMAKE_INSTALL_PREFIX="/usr" \

$(eval $(cmake-package))

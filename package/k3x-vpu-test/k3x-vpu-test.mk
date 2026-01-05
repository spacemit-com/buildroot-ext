K3X_VPU_TEST_VERSION:=0.0.2
K3X_VPU_TEST_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k3x-vpu-test
K3X_VPU_TEST_SITE_METHOD = local

MPP_CONF_OPTS = -DRUN_PLATFORM="RISCV" \
                        -DCI_LOG_LEVEL=4 \
                        -DARCH_RISCV="Y" \
                        -DCMAKE_INSTALL_PREFIX="/usr" \

$(eval $(cmake-package))

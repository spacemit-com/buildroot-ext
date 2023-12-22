K1X_JPU_VERSION:=1.0.0
K1X_JPU_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/k1x-jpu
K1X_JPU_SITE_METHOD = local

K1X_JPU_CONF_OPTS = -DRUN_PLATFORM="RISCV" \
                        -DCI_LOG_LEVEL=4 \
                        -DARCH_RISCV="Y" \
                        -DCMAKE_INSTALL_PREFIX="/usr" \

$(eval $(cmake-package))

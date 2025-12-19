################################################################################
#
# ESOS
#
################################################################################

# ESOS firmware version and source
ESOS_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/../package-src/esos
ESOS_SITE_METHOD = local

# Default build target: all cores
ESOS_BUILD_TARGET = all
ESOS_TARGET_CHIP = rt24
ESOS_TARGET_BOARD = k3_all_cores
ESOS_TARGET_DEFCONFIG = rt24_k3_all_cores_defconfig

# Toolchain configuration
ESOS_TOOLCHAIN_NAME = spacemit-toolchain-elf-newlib-x86_64-v1.0.9
ESOS_TOOLCHAIN_DIR = $(@D)/tools/toolchain/$(ESOS_TOOLCHAIN_NAME)

# Configure step: equivalent to ./build.sh config (non-interactive)
define ESOS_CONFIGURE_CMDS
    @echo "INFO: prepare to config sdk ..."
    rm -rf $(@D)/bsp/spacemit/.config
    rm -rf $(@D)/bsp/spacemit/.esos.config
    echo "export TARGET_CHIP=$(ESOS_TARGET_CHIP)" >> $(@D)/bsp/spacemit/.esos.config
    echo "export TARGET_BOARD=$(ESOS_TARGET_BOARD)" >> $(@D)/bsp/spacemit/.esos.config
    echo "export TARGET_DEFCONFIG=$(ESOS_TARGET_DEFCONFIG)" >> $(@D)/bsp/spacemit/.esos.config
    echo "export TARGET_ENTRY_POINT=" >> $(@D)/bsp/spacemit/.esos.config
    @echo ""
    @echo "INFO: target configuration is as follows:"
    @echo "INFO: -------------------------------------------------------------------------"
    @cat $(@D)/bsp/spacemit/.esos.config
    @echo "INFO: -------------------------------------------------------------------------"
    @echo "INFO: prepare to toolchain ..."
    if [ ! -d "$(ESOS_TOOLCHAIN_DIR)" ]; then \
        cd $(@D)/tools/toolchain/ && \
        tar -xf $(ESOS_TOOLCHAIN_NAME).tar.xz && \
        cd -; \
    fi
    touch $(@D)/bsp/spacemit/rtconfig.h

    @echo "INFO: create the verion id ..."

    commit_id=$$(cd $(ESOS_SITE) && git log | head -1); \
    version_id=$$(echo "$$commit_id" | tail -c 13); \
    __version_id=".verid=\"$(ESOS_TARGET_BOARD):$$version_id\""; \
    echo "$$__version_id"; \
    version_id_cfg_file=$(@D)/bsp/spacemit/platform/version_id_gen.cc; \
    rm -f $$version_id_cfg_file; \
	touch ${version_id_cfg_file}; \
    echo "struct version_id __versionid spacemit_verid = {" > $$version_id_cfg_file; \
    echo "    $$__version_id," >> $$version_id_cfg_file; \
    echo "};" >> $$version_id_cfg_file
endef

# Build step: call esos build.sh
define ESOS_BUILD_CMDS
    cd $(@D) && ./build.sh
endef

# Install step: copy esos.itb to BINARIES_DIR
define ESOS_INSTALL_TARGET_CMDS
	if [ -f "$(@D)/bsp/spacemit/k3_os0_rcpu.elf" ]; then \
		cp -f $(@D)/bsp/spacemit/k3_os0_rcpu.elf $(BINARIES_DIR)/; \
	fi
	@echo "INFO: Copied k3_os0_rcpu.elf to images/";
	if [ -f "$(@D)/bsp/spacemit/k3_os1_rcpu.elf" ]; then \
		cp -f $(@D)/bsp/spacemit/k3_os1_rcpu.elf $(BINARIES_DIR)/; \
	fi
	@echo "INFO: Copied k3_os1_rcpu.elf to images/";
	if [ -f "$(@D)/bsp/spacemit/esos.itb" ]; then \
		cp -f $(@D)/bsp/spacemit/esos.itb $(BINARIES_DIR)/; \
	fi
	@echo "INFO: Copied esos.itb to images/";
	@echo "INFO: esos build completed"
endef

# Clean command
define ESOS_CLEAN_CMDS
    @echo "INFO: prepare to clean esos ..."
    if [ -f "$(@D)/build.sh" ]; then \
        cd $(@D) && ./build.sh clean 2>/dev/null || true; \
    fi

endef

# Distclean command
define ESOS_DISTCLEAN_CMDS
    $(ESOS_CLEAN_CMDS)
    rm -rf $(ESOS_TOOLCHAIN_DIR)
endef

$(eval $(generic-package))

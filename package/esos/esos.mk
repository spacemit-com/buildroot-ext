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

# Menuconfig for core0
define ESOS_MENUCONFIG_CORE0_CMDS
	@echo "INFO: Configuring esos for core0 ..."
	# Prepare toolchain if not exists
	if [ ! -d "$(ESOS_TOOLCHAIN_DIR)" ]; then \
		cd $(@D)/tools/toolchain/ && \
		tar -xf $(ESOS_TOOLCHAIN_NAME).tar.xz && \
		cd -; \
	fi
	# Set configuration for core0
	rm -rf $(@D)/bsp/spacemit/.config
	rm -rf $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_CHIP=rt24" > $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_BOARD=k3_core0" >> $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_DEFCONFIG=rt24_k3_core0_defconfig" >> $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_ENTRY_POINT=" >> $(@D)/bsp/spacemit/.esos.config
	touch $(@D)/bsp/spacemit/rtconfig.h
	@echo "INFO: Loading core0 defconfig ..."
	# Load core0 defconfig if exists
	if [ -f "$(@D)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig" ]; then \
		cp $(@D)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig $(@D)/bsp/spacemit/.config; \
	fi
	# Calculate MD5 before menuconfig
	if [ -f "$(@D)/bsp/spacemit/.config" ]; then \
		md5sum $(@D)/bsp/spacemit/.config > $(@D)/bsp/spacemit/.config.md5.before; \
	fi
	@echo "INFO: Launching menuconfig for core0 ..."
	cd $(@D)/bsp/spacemit && scons --menuconfig
	# Calculate MD5 after menuconfig and save if changed
	if [ -f "$(@D)/bsp/spacemit/.config" ]; then \
		md5sum $(@D)/bsp/spacemit/.config > $(@D)/bsp/spacemit/.config.md5.after; \
		if ! diff -q $(@D)/bsp/spacemit/.config.md5.before $(@D)/bsp/spacemit/.config.md5.after > /dev/null 2>&1; then \
			echo "INFO: Configuration changed, saving to defconfig ..."; \
			if [ -d "$(@D)/bsp/spacemit/platform/rt24/k3_core0" ]; then \
				cp $(@D)/bsp/spacemit/.config $(@D)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig; \
				echo "INFO: Updated platform/rt24/k3_core0/rt24_k3_core0_defconfig"; \
			fi; \
		else \
			echo "INFO: Configuration not changed"; \
		fi; \
		rm -f $(@D)/bsp/spacemit/.config.md5.before $(@D)/bsp/spacemit/.config.md5.after; \
	fi
	@echo "INFO: core0 menuconfig completed"
endef

# Menuconfig for core1
define ESOS_MENUCONFIG_CORE1_CMDS
	@echo "INFO: Configuring esos for core1 ..."
	# Prepare toolchain if not exists
	if [ ! -d "$(ESOS_TOOLCHAIN_DIR)" ]; then \
		cd $(@D)/tools/toolchain/ && \
		tar -xf $(ESOS_TOOLCHAIN_NAME).tar.xz && \
		cd -; \
	fi
	# Set configuration for core1
	rm -rf $(@D)/bsp/spacemit/.config
	rm -rf $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_CHIP=rt24" > $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_BOARD=k3_core1" >> $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_DEFCONFIG=rt24_k3_core1_defconfig" >> $(@D)/bsp/spacemit/.esos.config
	echo "export TARGET_ENTRY_POINT=" >> $(@D)/bsp/spacemit/.esos.config
	touch $(@D)/bsp/spacemit/rtconfig.h
	@echo "INFO: Loading core1 defconfig ..."
	# Load core1 defconfig if exists
	if [ -f "$(@D)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig" ]; then \
		cp $(@D)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig $(@D)/bsp/spacemit/.config; \
	fi
	# Calculate MD5 before menuconfig
	if [ -f "$(@D)/bsp/spacemit/.config" ]; then \
		md5sum $(@D)/bsp/spacemit/.config > $(@D)/bsp/spacemit/.config.md5.before; \
	fi
	@echo "INFO: Launching menuconfig for core1 ..."
	cd $(@D)/bsp/spacemit && scons --menuconfig
	# Calculate MD5 after menuconfig and save if changed
	if [ -f "$(@D)/bsp/spacemit/.config" ]; then \
		md5sum $(@D)/bsp/spacemit/.config > $(@D)/bsp/spacemit/.config.md5.after; \
		if ! diff -q $(@D)/bsp/spacemit/.config.md5.before $(@D)/bsp/spacemit/.config.md5.after > /dev/null 2>&1; then \
			echo "INFO: Configuration changed, saving to defconfig ..."; \
			if [ -d "$(@D)/bsp/spacemit/platform/rt24/k3_core1" ]; then \
				cp $(@D)/bsp/spacemit/.config $(@D)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig; \
				echo "INFO: Updated platform/rt24/k3_core1/rt24_k3_core1_defconfig"; \
			fi; \
		else \
			echo "INFO: Configuration not changed"; \
		fi; \
		rm -f $(@D)/bsp/spacemit/.config.md5.before $(@D)/bsp/spacemit/.config.md5.after; \
	fi
	@echo "INFO: core1 menuconfig completed"
endef

# Update defconfig: sync from output to source directory
define ESOS_UPDATE_DEFCONFIG_CMDS
	@echo "INFO: Updating defconfig files to source directory ..."
	@echo "INFO: Source directory: $(ESOS_SITE)"
	@updated=0; \
	if [ -f "$(@D)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig" ]; then \
		mkdir -p $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core0; \
		cp $(@D)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig \
		   $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig; \
		echo "INFO: ✓ Updated core0 defconfig to source"; \
		updated=$$((updated + 1)); \
	else \
		echo "WARN: core0 defconfig not found in output directory"; \
	fi; \
	if [ -f "$(@D)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig" ]; then \
		mkdir -p $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core1; \
		cp $(@D)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig \
		   $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig; \
		echo "INFO: ✓ Updated core1 defconfig to source"; \
		updated=$$((updated + 1)); \
	else \
		echo "WARN: core1 defconfig not found in output directory"; \
	fi; \
	if [ -f "$(@D)/bsp/spacemit/platform/rt24/k3_all_cores/rt24_k3_all_cores_defconfig" ]; then \
		mkdir -p $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_all_cores; \
		cp $(@D)/bsp/spacemit/platform/rt24/k3_all_cores/rt24_k3_all_cores_defconfig \
		   $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_all_cores/rt24_k3_all_cores_defconfig; \
		echo "INFO: ✓ Updated all_cores defconfig to source"; \
		updated=$$((updated + 1)); \
	else \
		echo "WARN: all_cores defconfig not found in output directory"; \
	fi; \
	if [ $$updated -eq 0 ]; then \
		echo "ERROR: No defconfig files found to update!"; \
		echo "ERROR: Please run 'make esos-extract' first or configure via menuconfig"; \
		exit 1; \
	else \
		echo "INFO: Successfully updated $$updated defconfig file(s) to source directory"; \
	fi
endef

# Register menuconfig targets
esos-menuconfig-core0: esos-extract
	@echo "INFO: Configuring esos for core0 ..."
	@if [ ! -d "$(ESOS_DIR)/tools/toolchain/$(ESOS_TOOLCHAIN_NAME)" ]; then \
		cd $(ESOS_DIR)/tools/toolchain/ && \
		tar -xf $(ESOS_TOOLCHAIN_NAME).tar.xz && \
		cd -; \
	fi
	@rm -rf $(ESOS_DIR)/bsp/spacemit/.config
	@rm -rf $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_CHIP=rt24" > $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_BOARD=k3_core0" >> $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_DEFCONFIG=rt24_k3_core0_defconfig" >> $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_ENTRY_POINT=" >> $(ESOS_DIR)/bsp/spacemit/.esos.config
	@touch $(ESOS_DIR)/bsp/spacemit/rtconfig.h
	@echo "INFO: Loading core0 defconfig ..."
	@if [ -f "$(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig" ]; then \
		cp $(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig $(ESOS_DIR)/bsp/spacemit/.config; \
	fi
	@if [ -f "$(ESOS_DIR)/bsp/spacemit/.config" ]; then \
		md5sum $(ESOS_DIR)/bsp/spacemit/.config > $(ESOS_DIR)/bsp/spacemit/.config.md5.before; \
	fi
	@echo "INFO: Launching menuconfig for core0 ..."
	@mkdir -p $(ESOS_DIR)/.env/packages
	@if [ ! -f "$(ESOS_DIR)/.env/packages/Kconfig" ]; then \
		touch $(ESOS_DIR)/.env/packages/Kconfig; \
	fi
	@cd $(ESOS_DIR)/bsp/spacemit && HOME=$(ESOS_DIR) scons --menuconfig
	@if [ -f "$(ESOS_DIR)/bsp/spacemit/.config" ]; then \
		md5sum $(ESOS_DIR)/bsp/spacemit/.config > $(ESOS_DIR)/bsp/spacemit/.config.md5.after; \
		if ! diff -q $(ESOS_DIR)/bsp/spacemit/.config.md5.before $(ESOS_DIR)/bsp/spacemit/.config.md5.after > /dev/null 2>&1; then \
			echo "INFO: Configuration changed, saving to defconfig ..."; \
			cp $(ESOS_DIR)/bsp/spacemit/.config $(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig; \
			echo "INFO: Updated platform/rt24/k3_core0/rt24_k3_core0_defconfig"; \
		else \
			echo "INFO: Configuration not changed"; \
		fi; \
		rm -f $(ESOS_DIR)/bsp/spacemit/.config.md5.before $(ESOS_DIR)/bsp/spacemit/.config.md5.after; \
	fi
	@echo "INFO: core0 menuconfig completed"

esos-menuconfig-core1: esos-extract
	@echo "INFO: Configuring esos for core1 ..."
	@if [ ! -d "$(ESOS_DIR)/tools/toolchain/$(ESOS_TOOLCHAIN_NAME)" ]; then \
		cd $(ESOS_DIR)/tools/toolchain/ && \
		tar -xf $(ESOS_TOOLCHAIN_NAME).tar.xz && \
		cd -; \
	fi
	@rm -rf $(ESOS_DIR)/bsp/spacemit/.config
	@rm -rf $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_CHIP=rt24" > $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_BOARD=k3_core1" >> $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_DEFCONFIG=rt24_k3_core1_defconfig" >> $(ESOS_DIR)/bsp/spacemit/.esos.config
	@echo "export TARGET_ENTRY_POINT=" >> $(ESOS_DIR)/bsp/spacemit/.esos.config
	@touch $(ESOS_DIR)/bsp/spacemit/rtconfig.h
	@echo "INFO: Loading core1 defconfig ..."
	@if [ -f "$(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig" ]; then \
		cp $(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig $(ESOS_DIR)/bsp/spacemit/.config; \
	fi
	@if [ -f "$(ESOS_DIR)/bsp/spacemit/.config" ]; then \
		md5sum $(ESOS_DIR)/bsp/spacemit/.config > $(ESOS_DIR)/bsp/spacemit/.config.md5.before; \
	fi
	@echo "INFO: Launching menuconfig for core1 ..."
	@mkdir -p $(ESOS_DIR)/.env/packages
	@if [ ! -f "$(ESOS_DIR)/.env/packages/Kconfig" ]; then \
		touch $(ESOS_DIR)/.env/packages/Kconfig; \
	fi
	@cd $(ESOS_DIR)/bsp/spacemit && HOME=$(ESOS_DIR) scons --menuconfig
	@if [ -f "$(ESOS_DIR)/bsp/spacemit/.config" ]; then \
		md5sum $(ESOS_DIR)/bsp/spacemit/.config > $(ESOS_DIR)/bsp/spacemit/.config.md5.after; \
		if ! diff -q $(ESOS_DIR)/bsp/spacemit/.config.md5.before $(ESOS_DIR)/bsp/spacemit/.config.md5.after > /dev/null 2>&1; then \
			echo "INFO: Configuration changed, saving to defconfig ..."; \
			cp $(ESOS_DIR)/bsp/spacemit/.config $(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig; \
			echo "INFO: Updated platform/rt24/k3_core1/rt24_k3_core1_defconfig"; \
		else \
			echo "INFO: Configuration not changed"; \
		fi; \
		rm -f $(ESOS_DIR)/bsp/spacemit/.config.md5.before $(ESOS_DIR)/bsp/spacemit/.config.md5.after; \
	fi
	@echo "INFO: core1 menuconfig completed"

# Update defconfig to source
esos-update-defconfig: esos-extract
	@echo "INFO: Updating defconfig files to source directory ..."
	@echo "INFO: Source directory: $(ESOS_SITE)"
	@echo "INFO: Syncing core0 defconfig ..."
	@mkdir -p $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core0
	@cp $(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig \
	   $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core0/rt24_k3_core0_defconfig
	@echo "INFO: ✓ Updated k3_core0/rt24_k3_core0_defconfig to source"
	@echo "INFO: Syncing core1 defconfig ..."
	@mkdir -p $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core1
	@cp $(ESOS_DIR)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig \
	   $(ESOS_SITE)/bsp/spacemit/platform/rt24/k3_core1/rt24_k3_core1_defconfig
	@echo "INFO: ✓ Updated k3_core1/rt24_k3_core1_defconfig to source"
	@echo "INFO: Successfully updated defconfig files to source directory"

.PHONY: esos-menuconfig-core0 esos-menuconfig-core1 esos-update-defconfig

$(eval $(generic-package))

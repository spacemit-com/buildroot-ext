################################################################################
#
# secure-firmware: OP-TEE itb packing + secure u-boot variant -> images/sec/
#
# Single pseudo-package that produces the whole secure (OP-TEE) firmware set
# under $(BINARIES_DIR)/sec/, mirroring the k3-dev BSP SDK output/sec/:
#
#   1. pack tee.bin into a standalone optee.itb (the its lives in the
#      optee_os platform dir bsp-src/optee_os/.../plat-k3/optee.its, the
#      single source of truth shared with the BSP SDK; no local copy)
#   2. re-build u-boot in-place with the per-chip secure fragment
#      (configs/<chip>_sec.config, e.g. k3_sec.config) merged on top of the
#      base defconfig - reusing the uboot package build dir (uboot must have
#      been built first, non-secure)
#   3. relocate tee.bin under sec/ and collect every secure artifact there
#
# Chips without <chip>_sec.config skip step 2 but still get optee.itb.
#
################################################################################

SECURE_FIRMWARE_VERSION = 1.0
SECURE_FIRMWARE_SITE = $(BR2_EXTERNAL_Bianbu_PATH)/package/secure-firmware
SECURE_FIRMWARE_SITE_METHOD = local

# normal (non-secure) u-boot first - its build dir is reused for the
# in-place secure re-build; optee-os provides tee.bin
SECURE_FIRMWARE_DEPENDENCIES = uboot optee-os

SECURE_FIRMWARE_ITS = $(BR2_EXTERNAL_Bianbu_PATH)/../bsp-src/optee_os/core/arch/riscv/plat-k3/optee.its
SECURE_FIRMWARE_UBOOT_DIR = $(BUILD_DIR)/uboot-custom
SECURE_FIRMWARE_OUT_DIR = $(BINARIES_DIR)/sec
# reuse the uboot package's make opts (CROSS_COMPILE/ARCH/TEE/OPENSBI/HOSTCC)
SECURE_FIRMWARE_MAKE_OPTS = $(UBOOT_MAKE_OPTS)

define SECURE_FIRMWARE_PACK_OPTEE_ITB
	@echo "INFO: packing tee.bin into optee.itb ..."
	@test -f $(SECURE_FIRMWARE_ITS) || \
		(echo "ERROR: $(SECURE_FIRMWARE_ITS) not found;" \
		 "optee.its is maintained in optee_os plat-k3/ (commit 44a5e093f);" \
		 "do not create a local copy" && exit 1)
	# tee.bin source: fresh install from optee-os lives in images/ root;
	# on re-build it is already under sec/.
	@if [ -f $(BINARIES_DIR)/tee.bin ]; then \
		cp -f $(BINARIES_DIR)/tee.bin $(@D)/tee.bin; \
	elif [ -f $(SECURE_FIRMWARE_OUT_DIR)/tee.bin ]; then \
		cp -f $(SECURE_FIRMWARE_OUT_DIR)/tee.bin $(@D)/tee.bin; \
	else \
		echo "ERROR: tee.bin not found in $(BINARIES_DIR) or sec/ (run optee-os first)"; \
		exit 1; \
	fi
	cp $(SECURE_FIRMWARE_ITS) $(@D)/optee.its
	$(HOST_DIR)/bin/mkimage -C none -f $(@D)/optee.its $(@D)/optee.itb
	$(RM) $(@D)/optee.its $(@D)/tee.bin
endef

define SECURE_FIRMWARE_BUILD_SEC_UBOOT
	@echo "INFO: building secure (OP-TEE) u-boot variant ..."
	@if [ ! -f $(SECURE_FIRMWARE_UBOOT_DIR)/configs/k3_sec.config ]; then \
		echo "INFO: no k3_sec.config in uboot tree, skip secure u-boot build"; \
		exit 0; \
	fi
	@if [ ! -f $(SECURE_FIRMWARE_UBOOT_DIR)/scripts/kconfig/merge_config.sh ]; then \
		echo "ERROR: merge_config.sh missing (uboot not built/configured yet?)"; \
		exit 1; \
	fi
	# 1. backup current (non-secure) .config
	@if [ -f $(SECURE_FIRMWARE_UBOOT_DIR)/.config ]; then \
		cp $(SECURE_FIRMWARE_UBOOT_DIR)/.config $(SECURE_FIRMWARE_UBOOT_DIR)/.config.sec_bak; \
	fi
	# 2. (re)configure base defconfig then merge the secure fragment
	$(TARGET_CONFIGURE_OPTS) $(SECURE_FIRMWARE_MAKE_OPTS) $(BR2_MAKE) -C $(SECURE_FIRMWARE_UBOOT_DIR) \
		k3_defconfig
	cd $(SECURE_FIRMWARE_UBOOT_DIR) && \
		./scripts/kconfig/merge_config.sh -m .config configs/k3_sec.config
	# 3. build secure u-boot (in-tree, like mk_uboot_sec)
	$(TARGET_CONFIGURE_OPTS) $(SECURE_FIRMWARE_MAKE_OPTS) $(BR2_MAKE) -C $(SECURE_FIRMWARE_UBOOT_DIR)
	@mkdir -p $(SECURE_FIRMWARE_OUT_DIR)
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/.config $(SECURE_FIRMWARE_OUT_DIR)/.config
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/u-boot-env-default.bin $(SECURE_FIRMWARE_OUT_DIR)/env.bin
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/u-boot.itb $(SECURE_FIRMWARE_OUT_DIR)/
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/FSBL.bin $(SECURE_FIRMWARE_OUT_DIR)/ 2>/dev/null || true
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/u-boot-nodtb.bin $(SECURE_FIRMWARE_OUT_DIR)/
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/spl/u-boot-spl.bin $(SECURE_FIRMWARE_OUT_DIR)/ 2>/dev/null || true
	# secure DTBs carry the tdomain/udomain nodes
	@mkdir -p $(SECURE_FIRMWARE_OUT_DIR)/uboot
	@cp -f $(SECURE_FIRMWARE_UBOOT_DIR)/*.dtb $(SECURE_FIRMWARE_OUT_DIR)/uboot/ 2>/dev/null || true
	# 4. restore the non-secure .config so the source tree is not left in
	#    secure state (same as mk_uboot_sec)
	@if [ -f $(SECURE_FIRMWARE_UBOOT_DIR)/.config.sec_bak ]; then \
		mv -f $(SECURE_FIRMWARE_UBOOT_DIR)/.config.sec_bak $(SECURE_FIRMWARE_UBOOT_DIR)/.config; \
	fi
	# 5. rebuild the non-secure u-boot-env-default.bin (the secure build
	#    overwrote it with the optee mtdparts env)
	$(TARGET_CONFIGURE_OPTS) $(SECURE_FIRMWARE_MAKE_OPTS) $(BR2_MAKE) -C $(SECURE_FIRMWARE_UBOOT_DIR) \
		u-boot-nodtb.bin u-boot-env-default.bin
endef

define SECURE_FIRMWARE_BUILD_CMDS
	$(SECURE_FIRMWARE_PACK_OPTEE_ITB)
	$(SECURE_FIRMWARE_BUILD_SEC_UBOOT)
	# relocate tee.bin under sec/ (idempotent) - non-secure root stays tee-free
	@mkdir -p $(SECURE_FIRMWARE_OUT_DIR)
	@if [ -f $(BINARIES_DIR)/tee.bin ]; then \
		echo "INFO: relocating tee.bin into sec/ ..."; \
		mv -f $(BINARIES_DIR)/tee.bin $(SECURE_FIRMWARE_OUT_DIR)/tee.bin; \
	fi
	@cp -f $(@D)/optee.itb $(SECURE_FIRMWARE_OUT_DIR)/optee.itb
	@echo "INFO: secure firmware set at $(SECURE_FIRMWARE_OUT_DIR):"
	@ls -l --time-style=+%H:%M $(SECURE_FIRMWARE_OUT_DIR)/ | awk 'NR>1 {printf "  %-24s %8d bytes\n", $$NF, $$5}'
	@echo "INFO: secure u-boot built from $(SECURE_FIRMWARE_UBOOT_DIR) with configs/k3_sec.config merged"
endef

define SECURE_FIRMWARE_INSTALL_TARGET_CMDS
	@echo "INFO: secure firmware artifacts in $(SECURE_FIRMWARE_OUT_DIR)"
endef

# pseudo-package: no own sources, no install into target/staging
SECURE_FIRMWARE_INSTALL_IMAGES = NO
SECURE_FIRMWARE_INSTALL_STAGING = NO

$(eval $(generic-package))

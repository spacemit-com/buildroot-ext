include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/board/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/board/*/*/*.mk))


burn-image:
	@echo "Starting to burn image......."
	@(cd $(BINARIES_DIR);$(BINARIES_DIR)/fastboot_flash_emmc.sh)
	@if [ $$? -ne 0 ]; then \
		@echo "burning fails..."; \
		exit 1; \
	fi
	@echo "burning successful..."

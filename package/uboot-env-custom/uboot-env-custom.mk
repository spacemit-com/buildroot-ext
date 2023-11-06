################################################################################
#
# compile the custom uboot env file.
#
################################################################################

ENV_FILE = $(call qstrip, $(BR2_PACKAGE_UBOOT_ENV_CUSTOM_FILE))

ifneq ($(ENV_FILE),)

define UBOOT_ENV_CUSTOM_BUILD_CMDS

endef

endif
$(eval $(generic-package))



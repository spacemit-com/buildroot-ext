################################################################################
#
# blogbench
#
################################################################################

BLOGBENCH_VERSION = 3f28ad53d087b850719877d0b9c1631f99a16e31
BLOGBENCH_SITE = https://github.com/jedisct1/Blogbench.git
BLOGBENCH_SITE_METHOD = git
BLOGBENCH_LICENSE = BSD 2-Clause and MIT
#BLOGBENCH_LICENSE_FILES = LICENSE
BLOGBENCH_AUTORECONF = YES

define BLOGBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/blogbench $(TARGET_DIR)/usr/bin/blogbench
endef

$(eval $(autotools-package))

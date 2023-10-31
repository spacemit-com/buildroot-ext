################################################################################
#
# csmith
#
################################################################################

CSMITH_VERSION = 92069e4ad70493d21d093534e60c4ec7d8c3926f
CSMITH_SITE = $(call github,csmith-project,csmith,$(CSMITH_VERSION))
#CSMITH_SITE := $(TOPDIR)/../src/csmith
#CSMITH_SITE_METHOD=local
CSMITH_LICENSE = BSD
#GLM_LICENSE_FILES = manual.md

# GLM is a header-only library, it only makes sense
# to have it installed into the staging directory.
CSMITH_INSTALL_STAGING = YES
CSMITH_INSTALL_TARGET = YES

# Don't build libraries as GLM is header-only
#GLM_CONF_OPTS = \
#	-DGLM_TEST_ENABLE=OFF \
#	-DBUILD_SHARED_LIBS=OFF \
#	-DBUILD_STATIC_LIBS=OFF

$(eval $(cmake-package))

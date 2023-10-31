################################################################################
#
# PRIMESIEVE
#
################################################################################

PRIMESIEVE_VERSION = 35e99199c00ab0fccf6b2bf036b53e970682c468
PRIMESIEVE_SITE = $(call github,kimwalisch,primesieve,$(PRIMESIEVE_VERSION))

PRIMESIEVE_LICENSE = BSD 2-Clause

PRIMESIEVE_INSTALL_TARGET = YES

$(eval $(cmake-package))

################################################################################
#
# stockfish
#
################################################################################

STOCKFISH_VERSION = f0556dcbe3ba2fc804ab26d4552446602a75f064
STOCKFISH_SITE = https://github.com/official-stockfish/Stockfish.git
STOCKFISH_SITE_METHOD = git
STOCKFISH_LICENSE =  GPL-3.0 license

STOCKFISH_INSTALL_TARGET = YES

#this cmd download nnue file(about 45M, but now compress it into patch and apply when compile) from internet
#$(TARGET_MAKE_ENV) $(MAKE1) ARCH=riscv64 CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
#		-C $(@D)/src net

define STOCKFISH_BUILD_CMDS
    cp -rf $(TOPDIR)/../buildroot-ext/package/stockfish/nn-52471d*.nnue $(@D)/src/
	$(TARGET_MAKE_ENV) $(MAKE1) ARCH=riscv64 CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
	CXX="$(TARGET_CXX) $(TARGET_CXXFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/src all

endef

define STOCKFISH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/stockfish $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

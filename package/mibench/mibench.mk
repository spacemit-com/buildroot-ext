################################################################################
#
# mibench
#
################################################################################

MIBENCH_VERSION = 0f3cbcf6b3d589a2b0753cfb9289ddf40b6b9ed8
MIBENCH_SITE = https://gitee.com/spacemit/mibench.git
MIBENCH_SITE_METHOD = git
MIBENCH_LICENSE = GPLv2
MIBENCH_INSTALL_TARGET = YES
MIBENCH_PATRICIA_CFLAGS += $(TARGET_CFLAGS) -I"$(STAGING_DIR)/usr/include/tirpc"


#
#link failed
#	(cd $(@D)/office/rsynth;$(TARGET_CONFIGURE_OPTS) ./configure --host=i386-linux --target=riscv64 --prefix=./local;\
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
#		-C $(@D)/office/sphinx)

define MIBENCH_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/automotive/susan
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/automotive/qsort
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/automotive/basicmath all
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/automotive/bitcount

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/network/dijkstra
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(MIBENCH_PATRICIA_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/network/patricia

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/office/stringsearch
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/office/ispell
	($(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -lm" \
		-C $(@D)/office/rsynth)
	
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/security/blowfish
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/security/pgp/src clean
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/security/pgp/src riscv64-linux
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/security/rijndael
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/security/sha

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/telecomm/CRC32
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/telecomm/FFT
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/telecomm/adpcm/src
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/telecomm/gsm

	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/consumer/jpeg/jpeg-6a
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/consumer/lame/lame3.70
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/consumer/typeset/lout-3.24
	(cd $(@D)/consumer/mad/mad-0.14.2b;$(TARGET_CONFIGURE_OPTS) ./configure;\
		$(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/consumer/mad/mad-0.14.2b)
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/consumer/tiff-v3.5.4 all

	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/office/ghostscript/src
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"\
		-C $(@D)/office/ghostscript/src install

	(cd $(@D)/office/sphinx;$(TARGET_CONFIGURE_OPTS) ./configure --host=i386-linux --target=riscv64 --prefix=$(@D)/office/sphinx/local;cd -;)
	cp -f package/mibench/office/sphinx/src/examples/Makefile $(@D)/office/sphinx/src/examples/
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/office/sphinx/src
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/office/sphinx/src install
endef

define MIBENCH_INSTALL_TARGET_CMDS

	rm -rf $(TARGET_DIR)/usr/bin/mibench
	mkdir -p $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/automotive/susan/susan $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/automotive/qsort/qsort_large $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/automotive/qsort/qsort_small $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/automotive/basicmath/basicmath_small $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/automotive/basicmath/basicmath_large $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/automotive/bitcount/bitcnts $(TARGET_DIR)/usr/bin/mibench

 	$(INSTALL) -D -m 0755 $(@D)/network/dijkstra/dijkstra_large $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/network/dijkstra/dijkstra_small $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/network/patricia/patricia $(TARGET_DIR)/usr/bin/mibench

	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/blowfish
	$(INSTALL) -D -m 0755 $(@D)/security/blowfish/bf $(TARGET_DIR)/usr/bin/mibench/blowfish
	$(INSTALL) -D -m 0755 $(@D)/security/blowfish/bftest $(TARGET_DIR)/usr/bin/mibench/blowfish
	$(INSTALL) -D -m 0755 $(@D)/security/blowfish/bfspeed $(TARGET_DIR)/usr/bin/mibench/blowfish

	$(INSTALL) -D -m 0755 $(@D)/security/pgp/src/pgp $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/security/rijndael/rijndael $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/security/sha/sha $(TARGET_DIR)/usr/bin/mibench

	$(INSTALL) -D -m 0755 $(@D)/telecomm/CRC32/crc $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/telecomm/FFT/fft $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/telecomm/adpcm/src/rawcaudio $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/telecomm/adpcm/src/rawdaudio $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/telecomm/adpcm/src/timing $(TARGET_DIR)/usr/bin/mibench
	
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/gsm
	$(INSTALL) -D -m 0755 $(@D)/telecomm/gsm/bin/tcat $(TARGET_DIR)/usr/bin/mibench/gsm
	$(INSTALL) -D -m 0755 $(@D)/telecomm/gsm/bin/toast $(TARGET_DIR)/usr/bin/mibench/gsm
	$(INSTALL) -D -m 0755 $(@D)/telecomm/gsm/bin/untoast $(TARGET_DIR)/usr/bin/mibench/gsm

	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/jpeg
	$(INSTALL) -D -m 0755 $(@D)/consumer/jpeg/jpeg-6a/rdjpgcom $(TARGET_DIR)/usr/bin/mibench/jpeg
	$(INSTALL) -D -m 0755 $(@D)/consumer/jpeg/jpeg-6a/wrjpgcom $(TARGET_DIR)/usr/bin/mibench/jpeg
	$(INSTALL) -D -m 0755 $(@D)/consumer/jpeg/jpeg-6a/cjpeg $(TARGET_DIR)/usr/bin/mibench/jpeg
	$(INSTALL) -D -m 0755 $(@D)/consumer/jpeg/jpeg-6a/djpeg $(TARGET_DIR)/usr/bin/mibench/jpeg
	$(INSTALL) -D -m 0755 $(@D)/consumer/jpeg/jpeg-6a/jpegtran $(TARGET_DIR)/usr/bin/mibench/jpeg

	$(INSTALL) -D -m 0755 $(@D)/consumer/lame/lame3.70/lame $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/consumer/typeset/lout-3.24/lout $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/consumer/mad/mad-0.14.2b/madplay $(TARGET_DIR)/usr/bin/mibench
	
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/fax2tiff $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/fax2ps $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/gif2tiff $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/pal2rgb $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/ppm2tiff $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/rgb2ycbcr $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/thumbnail $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/ras2tiff $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiff2bw $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiff2rgba $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiff2ps $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffcmp $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffcp $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffdither $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffdump $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffinfo $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffmedian $(TARGET_DIR)/usr/bin/mibench/tiff
	$(INSTALL) -D -m 0755 $(@D)/consumer/tiff-v3.5.4/tools/tiffsplit $(TARGET_DIR)/usr/bin/mibench/tiff
		
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/buildhash $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/findaffix $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/tryaffix $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/ispell $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/icombine $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/ijoin $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/munchlist $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/subset $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/sq $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/unsq $(TARGET_DIR)/usr/bin/mibench/ispell
	$(INSTALL) -D -m 0755 $(@D)/office/ispell/zapdups $(TARGET_DIR)/usr/bin/mibench/ispell

	$(INSTALL) -D -m 0755 $(@D)/office/stringsearch/search_large $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/office/stringsearch/search_small $(TARGET_DIR)/usr/bin/mibench
	$(INSTALL) -D -m 0755 $(@D)/office/rsynth/say $(TARGET_DIR)/usr/bin/mibench

	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/ghostscript/
	cp -rf $(@D)/office/ghostscript/bin $(TARGET_DIR)/usr/bin/mibench/ghostscript/
	cp -rf $(@D)/office/ghostscript/data $(TARGET_DIR)/usr/bin/mibench/ghostscript/
	cp -rf $(@D)/office/ghostscript/share $(TARGET_DIR)/usr/bin/mibench/ghostscript/
	
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/mibench/sphinx
	cp -rf $(@D)/office/sphinx/src/examples/local/bin/* $(TARGET_DIR)/usr/bin/mibench/sphinx/
	

endef

$(eval $(generic-package))

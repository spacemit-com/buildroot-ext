################################################################################
#
# ncnn
#
################################################################################

NCNN_VERSION = a961ab992e2e4bf1cb950423bd7c2e2d40eb4ea2
NCNN_SITE = https://github.com/Tencent/ncnn.git
NCNN_SITE_METHOD = git

NCNN_CONF_OPTS = \
	-DENABLE_MODTOOL=OFF \
	-DENABLE_TESTING=OFF \
	-DENABLE_PROFILING=OFF

NCNN_INSTALL_STAGING = YES

$(eval $(cmake-package))

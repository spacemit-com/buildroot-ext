VK_GL_CTS_VERSION := 0.1.0
VK_GL_CTS_SITE = $(TOPDIR)/../package-src/vk-gl-cts
VK_GL_CTS_SITE_METHOD = local
VK_GL_CTS_SUPPORTS_IN_SOURCE_BUILD = NO
VK_GL_CTS_DEPENDENCIES = wayland libegl libgles
VK_GL_CTS_BUILDDIR = $(@D)/../vk-gl-cts_build

define VK_GL_CTS_BUILD_CMDS
	$(warning here is $(@D)/build)
	rm -rf $(VK_GL_CTS_BUILDDIR)
	cd $(@D)
	mkdir -p $(VK_GL_CTS_BUILDDIR)
	rm -rf $(@D)/CMakeCache.txt $(@D)/CMakeFiles
	(cd $(VK_GL_CTS_BUILDDIR); $(TARGET_MAKE_ENV) cmake $(@D) -DCMAKE_TOOLCHAIN_FILE="$(HOST_DIR)/share/buildroot/toolchainfile.cmake" -DDEQP_TARGET=wayland -DGLCTS_GTF_TARGET=gles32 -DWAYLAND_SCANNER=$(HOST_DIR)/bin/wayland-scanner -DSELECTED_BUILD_TARGETS="deqp-egl deqp-gles2" -DCMAKE_INSTALL_PREFIX=$(TARGET_DIR)/usr; $(TARGET_MAKE_ENV) cmake --build external/openglcts; $(MAKE) install)
endef

define VK_GL_CTS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/external/openglcts/modules/cts-runner $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/external/openglcts/modules/glcts $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/modules/egl/deqp-egl $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/modules/gles2/deqp-gles2 $(TARGET_DIR)/usr/bin/
	cp -rf $(VK_GL_CTS_BUILDDIR)/modules/gles2/gles2/ $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/modules/gles3/deqp-gles3 $(TARGET_DIR)/usr/bin/
	cp -rf $(VK_GL_CTS_BUILDDIR)/modules/gles3/gles3/ $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/modules/gles31/deqp-gles31 $(TARGET_DIR)/usr/bin/
	cp -rf $(VK_GL_CTS_BUILDDIR)/modules/gles31/gles31/ $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(VK_GL_CTS_BUILDDIR)/external/spirv-tools/spirv-tools/source/libSPIRV-Tools-shared.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))

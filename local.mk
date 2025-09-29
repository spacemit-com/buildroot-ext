#for dev purpose , lists pkg-source dir here and buildroot use it priority
#为了方便源码开发，这里提供各模块源码路径覆写，buildroot优先使用

#e.g example
#XXX is package name defined in buildroot
#XXX_OVERRIDE_SRCDIR = /path/to/xxx/dir
#XXX_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS = --exclude unittests --exclude test.txt  --include .git

# please config linux dir in menuconfig
# LINUX_OVERRIDE_SRCDIR = $(TOPDIR)/../bsp-src/linux-6.1
UBOOT_OVERRIDE_SRCDIR = $(TOPDIR)/../bsp-src/uboot-2022.10
OPENSBI_OVERRIDE_SRCDIR = $(TOPDIR)/../bsp-src/opensbi
MESA3D_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/mesa3d
IMG_GPU_POWERVR_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/img-gpu-powervr
GLMARK2_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/glmark2
FACTORYTEST_OVERRIDE_SRCDIR = $(TOPDIR)/../package-src/factorytest

export MESA_LOADER_DRIVER_OVERRIDE=pvr
export XDG_RUNTIME_DIR=/root
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins/platforms
export QT_QPA_PLATFORM=wayland
DRM_DEVICE="card1"
for entry in /sys/class/drm/card*-DP-*; do
    [ -e "$entry" ] && DRM_DEVICE=$(basename "$entry" | grep -o 'card[0-9]*') && break
done
XDG_RUNTIME_DIR=/root weston --idle-time=0 --drm-device=$DRM_DEVICE --log=/var/log/weston

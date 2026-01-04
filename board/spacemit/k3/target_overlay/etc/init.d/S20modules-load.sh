#!/bin/sh

MODULE_PATH="/lib/modules/6.12.16/kernel/drivers/net/wireless/realtek/rtw89"
MODULE_NAME="rtw89_8852be.ko"
MODULE_FILE="${MODULE_PATH}/${MODULE_NAME}"

setup()
{
    if [ -f "${MODULE_FILE}" ]; then
        modprobe rtw89_8852be
        sleep 1
    else
        echo "error: file not exist: ${MODULE_FILE}" >&2
        exit 1
    fi
}

clean()
{
    echo "nothing to do for clean"
}

OPT=$1
case "$1" in
    start)
        echo "Starting modules-load..."
        setup
        ;;
    stop)
        echo "Stopping modules-load..."
        clean
        ;;
    restart|reload)
        clean
        setup
        ;;
    *)
        echo "Usage: $0 {start|stop|reload}"
        exit 1
esac
exit $?

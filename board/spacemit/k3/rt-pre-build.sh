#!/bin/bash -e

LINUX_DIR=/build/bsp-src/linux-6.12
if [ ! -d "$LINUX_DIR" ]; then
	LINUX_DIR=$O/../../bsp-src/linux-6.12
fi

echo "$LINUX_DIR"

if [ -f $LINUX_DIR/.applied_patches_list ]; then
    echo "Linux already patched with PREEMPT_RT patch"
else
    echo "Patching linux with PREEMPT_RT patch"
    ./support/scripts/apply-patches.sh $LINUX_DIR $LINUX_DIR/rt-linux *.patch
fi

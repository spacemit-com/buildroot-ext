#!/bin/bash -e

LINUX_DIR=$O/../../bsp-src/linux-6.6

if [ -f $LINUX_DIR/.applied_patches_list ]; then
    echo "Linux already patched with PREEMPT_RT patch"
else
    echo "Patching linux with PREEMPT_RT patch"
    ./support/scripts/apply-patches.sh $LINUX_DIR $LINUX_DIR/rt-linux *.patch
fi

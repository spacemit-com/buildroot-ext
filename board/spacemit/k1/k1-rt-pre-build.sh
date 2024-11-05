#!/bin/bash -e

if [ -f $O/.stamp_patched ]; then
    echo "Linux already patched with PREEMPT_RT patch"
else
    echo "Patching linux with PREEMPT_RT patch"
    ./support/scripts/apply-patches.sh ../bsp-src/linux-6.6/ ../bsp-src/linux-6.6/rt-linux *.patch
    touch $O/.stamp_patched
fi

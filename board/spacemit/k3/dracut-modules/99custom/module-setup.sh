#!/bin/bash

# called by dracut
check() {
    # do not add this module by default
    return 255
}

# called by dracut
depends() {
    return 0
}

# called by dracut
install() {
    inst_multiple -o ps grep more cat rm strace free showmount \
        ping netstat rpcinfo vi scp ping6 ssh \
        fsck fsck.ext2 fsck.ext4 fsck.ext3 fsck.ext4dev fsck.f2fs fsck.vfat e2fsck resize2fs mount blkid

    # OP-TEE userland (optee-client / optee-examples / optee-test)
    inst_multiple -o xtest tee-supplicant \
        optee_example_hello_world optee_example_aes optee_example_secure_storage \
        optee_example_random

    # OP-TEE TAs (.ta are not executables, inst them explicitly)
    local ta_dir="$dracutsysrootdir/lib/optee_armtz"
    if [ -d "$ta_dir" ]; then
        inst_dir /lib/optee_armtz
        local ta
        for ta in "$ta_dir"/*.ta; do
            [ -f "$ta" ] && inst "$ta" "/lib/optee_armtz/$(basename "$ta")"
        done
    fi

    # Copy firmware files to initramfs
    local fw="$dracutsysrootdir/../../../output/esos"
    inst_dir /lib/firmware
    inst "$fw/rt24_os0_rcpu.elf" /lib/firmware/rt24_os0_rcpu.elf 2>/dev/null
    inst "$fw/rt24_os1_rcpu.elf" /lib/firmware/rt24_os1_rcpu.elf 2>/dev/null
}

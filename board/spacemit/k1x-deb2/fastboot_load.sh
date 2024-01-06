#!/bin/sh

fastboot stage factory/FSBL.bin
fastboot continue
sleep 2

fastboot stage u-boot-opensbi.itb
fastboot continue
sleep 3

fastboot stage uImage.itb
fastboot continue

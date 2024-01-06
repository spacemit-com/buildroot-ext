@echo off

fastboot stage factory/FSBL.bin
fastboot continue
timeout /t 2


fastboot stage u-boot-opensbi.itb
fastboot continue
timeout /t 3

fastboot stage uImage.itb
fastboot continue

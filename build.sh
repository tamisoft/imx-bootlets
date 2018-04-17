#!/bin/sh

make CROSS_COMPILE=arm-poky-linux-gnueabi- BOARD=imx23_dwams_dev linux_prep boot_prep power_prep otp_prep CC=arm-poky-linux-gnueabi-gcc LD=arm-poky-linux-gnueabi-ld

./elftosb -c otpflasher.bd -z -d -o otpflasher.sb

#!/bin/bash

# Automatically re-run script under sudo if not root
if [ $(id -u) -ne 0 ]; then
    echo "Re-running script under sudo..."
    sudo "$0" "$@"
    exit
fi

IS_ARM64=`file /usr/bin/ld | grep aarch64-linux-gnu-ld | wc -l`
IS_ARM32=`file /usr/bin/ld | grep arm-linux-gnueabihf-ld | wc -l`

if [ $IS_ARM64 -eq 1 ]; then
    cp aarch64/sd_update /usr/bin/
elif [ $IS_ARM32 -eq 1 ]; then
    cp armhf/sd_update /usr/bin/
else
    echo "error: please run this script on target board."
    echo 1
fi
chmod 755 /usr/bin/sd_update
echo "done."

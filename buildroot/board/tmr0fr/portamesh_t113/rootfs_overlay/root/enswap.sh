#!/bin/sh
modprobe zram
zramctl -s 512M /dev/zram0
mkswap -U clear /dev/zram0
swapon --discard --priority 100 /dev/zram0


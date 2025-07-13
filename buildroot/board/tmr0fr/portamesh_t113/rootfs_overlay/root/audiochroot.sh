#!/bin/sh
mount -o bind /dev /opt/debian/dev
mount -o bind /dev/pts /opt/debian/dev/pts
mount -o bind /dev/shm /opt/debian/dev/shm
mount -o bind /proc /opt/debian/proc
mount -o bind /sys /opt/debian/sys
mount -o bind /tmp /opt/debian/tmp
mount --bind /run /opt/debian/run 

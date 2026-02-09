PortaMesh 1 (Allwinner T113-based)
===============

PortaMesh is a portable wireless communication "tablet".
It's main features includes :
- LoRa wireless (Meshtastic compatible)
- WiFi N - 2.4Ghz single band   (RTL8723DS)
- Bluetooth 4.2 + BLE           (RTL8723DS)
- GPS/GNSS
- 5" 480*800 IPS LCD - 10 points capacitive touchscreen
- Side mounted 0.96" OLED display for notifications
- 9 axis IMU : Accelerometer + Gyroscope + Compass
- Allwinner T113-s3/-s4 CPU : dual-core 1.2GHz ARM Cortex-A7 CPU
                            (+ 2 heterogeneous cores : HiFi4 DSP + RISCV)
- 128MB(-s3) or 256MB(-s4) DDR3 RAM
- SDXC card slot - used for system and user data
- USB-C socket (device-mode only)
- Quasi-mainline U-Boot and Linux kernel

[More info at : http://wiki.tmr0.fr/index.php/PortaMesh !]

How to build
============

$ make tmr0fr_porta_mesh_t113_defconfig
$ make

Wifi
==========

Edit /board/tmr0fr/portamesh_t113/rootfs_overlay/etc/wpa_supplicant.conf
(or /etc/wpa_supplicant.conf once booted) :

* Replace YOURSSID with your AP ssid
* Replace YOURPASSWD with your AP password
* (optionally) Replace "WPA-PSK" as needed

Don't forget to re-build the SD-card image after changing Wifi credentials :

$ make

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Insert the microSD card and plug in a USB-C cable to boot the system.
Wait a few seconds for the system to boot and display the splash screen.
If nothing happens, please consult : http://wiki.tmr0.fr/index.php/PortaMesh (french)

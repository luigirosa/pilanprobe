# pilanprobe
RaspberryPI 4 LAN probe

## Hardware
 * Raspberry PI 4
 * 32 Gb microSD
 * Active PoE splitter [Amazon](https://www.amazon.it/gp/product/B0822QCTND/ref=ppx_yo_dt_b_asin_title_o01_s01?ie=UTF8&psc=1)
 * Touch screen [Amazon](https://www.amazon.it/gp/product/B07WSVS1Q1/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1)

## Software 
 * [Raspbian](https://www.raspberrypi.org/software/)
 * [LCD driver](https://github.com/goodtft/LCD-show)

## Installation Procedure
 * Connect the microSD to a PC
 * Install Raspberry PI Imager and write the standard Raspberry OS image (with desktop) to the SD 
 * Extract the microSD card and insert again in the PC
 * In the boot partition (mounted as root by Windows, is the partition with `start.elf` file) create an empty file named `ssh`
 * Eject the microSD, put it on Raspberry and boot the device connected to the network, get the IP address from DHCP server
 * Open a ssh session with the Raspberry, username `pi`, pass `raspberry`
 * Update the OS with `sudo apt update` and then `sudo apt full-upgrade` and reboot the device
 * Install the touch screen driver for MHS-3.5” RPi Display(MHS3528) [Documentation](http://www.lcdwiki.com/MHS-3.5inch_RPi_Display) 
 * sudo `raspi-config`: 
   ** 8->Update
   ** 1->S7 enable spalsh screen
   ** 5->L2->None of the above->UTC
    

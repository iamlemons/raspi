#!/bin/bash
# Script to setup a Raspberry Pi for the first time

# set paths to our configuration files
RPI_MAINTENANCE_FILE=maintain_pi.sh
RPI_WIFI_SETUP_FILE=setup_wifi.sh

# first, verify that the user is root
if [[ $EUID -ne 0 ]]; then 
    echo "Must be run as root!"
    exit 1
fi

# first, we'll update our key `apt-get`, `easy_install`, and `Python` libraries
# to the latest distributions using what will then become our maintenance script
if [[ ! -f ./$RPI_MAINTENANCE_FILE ]]; then
    echo "RPi maintenance file $RPI_MAINTENANCE_FILE missing... Try recloning the repo."
    exit 1
else
    bash ./$RPI_MAINTENANCE_FILE
fi

# next, so that we can easily edit our files, install and configure vim
apt-get install vim 
update-alternatives --config editor

# next we change the keyboard configuration
# NOTE: we will want to select the Generic US keyboard layout
apt-get install console-common
dpkg-reconfigure keyboard-configuration

# once that's done, change the password to user Pi for added security
passwd

# prompt the user if they want to also setup Wi-Fi
read -prompt "Do you want to configure Wi-Fi access? [y/N] >>> " WIFI_RESP
if [[ $WIFI_RESP =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if [[ ! -f ./$RPI_WIFI_SETUP_FILE ]]; then
        echo "Wi-Fi setup file $RPI_WIFI_SETUP_FILE missing... Aborting Wi-Fi setup."
    else
        bash ./$RPI_WIFI_SETUP_FILE
    fi
fi

# to persist the changes we just made, reboot now
echo "Setup complete! Rebooting to persist changes..."
reboot

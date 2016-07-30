#!/bin/bash
# Script to setup a Raspberry Pi 

# first, verify that the user is root
if [[ $EUID -ne 0 ]]; then 
    echo "Must be run as root!"
    exit
fi

# first, we'll update our `apt-get` 
apt-get update
apt-get upgrade

# next, so that we can easily edit our files, install and configure vim
apt-get install vim 
update-alternatives --config editor

# next, we'll update `easy_install`
easy_install -U distribute

# then we'll update our Python libraries to ensure they're the latest
apt-get install python
apt-get install python-setuptools
apt-get install python-pip

# and update the RPi Python libraries
pip install RPi.GPIO
pip install pySerial
pip install nose

# and we'll give ourselves a better Python environment to test in
pip install ipython

# next we change the keyboard configuration
apt-get install console-common
dpkg-reconfigure keyboard-configuration

# NOTE: we will want to select the Generic US keyboard layout
# once that's done, change the password to user Pi for added security
passwd

# prompt the user if they want to also setup Wi-Fi
read -r -p "Do you want to configure Wi-Fi access? [y/N] >>> " WIFI_RESP
if [[ $WIFI_RESP =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if [[ ! -f ./setup_wifi.sh ]]; then
        echo "Wi-Fi setup file missing... Rebooting."
    else
        bash ./setup_wifi.sh
    fi
fi

# to persist the changes we just made, reboot now
echo "Setup succeeded! Rebooting to persist changes..."
reboot

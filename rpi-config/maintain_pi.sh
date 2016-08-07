#!/bin/bash
# Script to setup and maintain a Raspberry Pi
# Ensures key libraries remain up to date

# first, verify that the user is root
if [[ $EUID -ne 0 ]]; then 
    echo "Must be run as root!"
    exit 1
fi

# first, we'll update `apt-get` 
apt-get update
apt-get dist-upgrade

# next, we'll update `easy_install`
easy_install -U distribute

# then we'll update our Python libraries to ensure they're the latest
apt-get install python
apt-get install python-setuptools
apt-get install python-pip

# and update the RPi Python libraries
pip install -U RPi.GPIO
pip install -U pySerial
pip install -U nose

# and we'll give ourselves a better Python environment to test in
pip install -U ipython

exit 0

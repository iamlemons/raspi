#!/bin/bash
# Script to configure our Wi-Fi network settings
# so we automatically connect going forward

# first, confirm that we're running as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Must be run as root!"
    exit 1
fi

# set the path to WPA_SUPPLICANT_FILE
WPA_SUPPLICANT_FILE=/etc/wpa_supplicant/wpa_supplicant.conf

read -prompt "Enter an SSID >>> " SSID

# check that the given SSID exists
if [[ -z "$SSID" ]]; then
    echo "No SSID provided... Aborting Wi-Fi config and rebooting."
    exit 1
elif [[ $(sudo iw dev wlan0 scan | grep "$SSID") ]]; then
    read -prompt "Enter the password for $SSID >>> " SSID_PASSWD
    if [[ ! -z "$SSID_PASSWD" ]]; then
        # add the network information to the $WPA_SUPPLICANT_FILE
        echo "" >> $WPA_SUPPLICANT_FILE
        echo "network={" >>  $WPA_SUPPLICANT_FILE
        echo "    ssid=" $SSID >> $WPA_SUPPLICANT_FILE 
        echo "    psk=" $SSID_PASSWD >> $WPA_SUPPLICANT_FILE 
        echo "}" >> $WPA_SUPPLICANT_FILE
        echo "" >> $WPA_SUPPLICANT_FILE
    else 
        echo "No password provided... Aborting Wi-Fi config and rebooting."
        exit 1
    fi
else 
     echo "SSID not found... Aborting Wi-Fi config and rebooting." 
     exit 1
fi 

exit 0

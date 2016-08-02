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

read -p "Enter an SSID >>> " SSID

# check that an SSID was provided
if [[ -z "$SSID" ]]; then
    echo "No SSID provided... Aborting Wi-Fi config and rebooting."
    exit 1
elif [[ $(sudo iw dev wlan0 scan | grep "$SSID") ]]; then
    read -s -p "Enter the password for $SSID >>> " SSID_PASSWD1
    echo ""
    read -s -p "Re-enter the password for $SSID >>> " SSID_PASSWD2
    
    # affirm that SSID_PASSWD1 was provided and matches SSID_PASSWD2
    if [[ (! -z "$SSID_PASSWD1") && ("$SSID_PASSWD1 == $SSID_PASSWD2") ]]; then
        # add the network information to the $WPA_SUPPLICANT_FILE
        echo "" >> $WPA_SUPPLICANT_FILE
        echo "network={" >>  $WPA_SUPPLICANT_FILE
        echo "    ssid=$SSID" >> $WPA_SUPPLICANT_FILE 
        echo "    psk=$SSID_PASSWD1" >> $WPA_SUPPLICANT_FILE 
        echo "}" >> $WPA_SUPPLICANT_FILE
        echo "" >> $WPA_SUPPLICANT_FILE
    else 
        echo "Invalid credentials... Aborting Wi-Fi config and rebooting."
        exit 1
    fi
else 
     echo "SSID not found... Aborting Wi-Fi config and rebooting." 
     exit 1
fi 

exit 0

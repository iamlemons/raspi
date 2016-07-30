#!/bin/bash
# Script to configure our Wi-Fi network settings
# so we automatically connect going forward

# first, confirm that we're running as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Must be run as root!"
    exit
fi

echo "Enter an SSID >>> "
read SSID

# check that the given SSID exists
if [[ -z "$SSID" ]]; then
    echo "No SSID provided... Aborting Wi-Fi config and rebooting."
elif [[ $(sudo iw dev wlan0 scan | grep "$SSID") ]]; then
    echo "Enter the password for the SSID >>> "
    read SSID_PASSWD
    if [[ ! -z "$SSID_PASSWD" ]]; then
        WPA_SUPPLICANT_FILE=/etc/wpa_supplicant/wpa_supplicant.conf
        echo "" >> $WPA_SUPPLICANT_FILE
        echo "network={" >>  $WPA_SUPPLICANT_FILE
        echo "    ssid=" $SSID >> $WPA_SUPPLICANT_FILE 
        echo "    psk=" $SSID_PASSWD >> $WPA_SUPPLICANT_FILE 
        echo "}" >> $WPA_SUPPLICANT_FILE
        echo "" >> $WPA_SUPPLICANT_FILE
    else 
        echo "No password provided... Aborting Wi-Fi config and rebooting."
    fi 
else 
     echo "SSID not found... Aborting Wi-Fi config and rebooting." 
fi 

exit

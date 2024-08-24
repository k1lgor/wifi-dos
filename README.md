# WiFi DoS

## Simple wifi DoS attack with the use of

- [nmcli](https://developer-old.gnome.org/NetworkManager/stable/nmcli.html) - Network Manager Command Line Interface
- [macchanger](https://en.kali.tools/?p=1404) - an utility that makes the maniputation of MAC addresses of network interfaces easier
- [aircrack-ng](https://www.aircrack-ng.org/doku.php?id=Main) - a complete suite of tools to assess WiFi network security

## Usage

```bash
# change permission of the file to be executable
chmod +x wifi-dos.sh

# to see all the networks within the range of your wifi adapter
nmcli dev wifi

# need to copy the targeted SSID and the number of the channel and replace it in the script
# aircrack-ng requires sudo
sudo ./wifi-dos.sh
```

![dos](./ezgif.com-gif-maker.gif)

## Code explained

The selected code is a shell script that implements a WiFi Denial of Service (DoS) attack tool. It targets a specific WiFi network by disconnecting all connected clients. Here's a breakdown of the code:

1. The script starts with a shebang (`#!/bin/bash`) that specifies the interpreter to execute the script.

2. The `set -e` command ensures that the script exits immediately if any command returns a non-zero status.

3. A `cleanup` function is defined to clean up resources and exit the script. It stops the monitor mode interface, restarts the network manager, and exits.

4. A trap is set to call the `cleanup` function when the script exits.

5. A `run_command` function is defined to run a command with a timeout and handle errors. If the command fails or times out, it prints an error message and returns a non-zero status.

6. The script checks if it's being run as root. If not, it prints a message and exits with a non-zero status.

7. The script prompts the user to enter the target MAC address. It validates the MAC address format and exits with an error message if the format is invalid.

8. The script starts the monitor mode interface using the `airmon-ng start wlan0` command. It then waits for 7 seconds.

9. The script configures the interface by bringing it down, changing its MAC address using `macchanger -r`, and bringing it back up.

10. The script starts a packet capture using the `airodump-ng` command and stores the process ID (PID) of the running process in the `AIRODUMP_PID` variable.

11. The script enters a loop that deauthenticates clients from the target MAC address. It runs the `aireplay-ng --deauth 5 -a "$TARGET_MAC" wlan0mon` command 200 times, with a 5-second delay between each iteration.

12. Finally, the script kills the `airodump-ng` process using the `kill $AIRODUMP_PID` command.

This script is designed to disrupt WiFi networks by disconnecting all connected clients. It uses various network utilities like `airmon-ng`, `macchanger`, and `aireplay-ng` to achieve its goal.

## Disclaimer

> This script is for educational purpose only.
>
> Any malicious use of the content will not hold the author responsible.

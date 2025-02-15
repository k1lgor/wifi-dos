# WiFi DoS

## Overview

This script implements a WiFi Denial of Service (DoS) attack tool that targets a specific WiFi network by disconnecting all connected clients. It uses tools such as `nmcli`, `macchanger`, and `aircrack-ng` to perform the attack.

## Tools Used

- [nmcli](https://developer-old.gnome.org/NetworkManager/stable/nmcli.html) - Network Manager Command Line Interface for managing network connections.
- [macchanger](https://en.kali.tools/?p=1404) - An utility for easily manipulating MAC addresses of network interfaces.
- [aircrack-ng](https://www.aircrack-ng.org/doku.php?id=Main) - A comprehensive suite of tools for assessing WiFi network security.

## Usage

1. Make the script executable

```bash
chmod +x wifi-dos.sh
```

2. Identify target networks

Use `nmcli` to list available WiFi networks within range:

```bash
nmcli dev wifi
```

Note the SSID and channel number of the target network.

3. Run the script

Since `aircrack-ng` requires root privileges, execute the script with `sudo`:

```bash
sudo ./wifi-dos.sh
```

4. Provide target details

When prompted, enter the MAC address of the target network in the format `XX:XX:XX:XX:XX:XX`.

![dos](./ezgif.com-gif-maker.gif)

## Code explained

**1. Initization**

- The script begins with a shebang (`#!/bin/bash`) to specify the interpreter.
- The `set -e` command ensures the script exits immediately if any command fails,

**2. Resource Cleanup**

- A `cleanup` function is defined to stop the monitor mode interface, restart the network manager, and exit gracefully.
- A trap is set to invode the `cleanup` function when the script exits.

**3. Command Execution**

- A `run_command` function is implemented to execute commands with a timeout and handle errors. If a command fails or times out, an error messsage is displayed.

**4. Root Check**

- The script verifies if it is being run as root. If not, it displays an error message and exits.

**5. MAC Address Validation**

- The user is prompted to input the target MAC address, which is validated for correctness using a regular expression.

**6. Monitor Mode Setup**

- The script starts monitor mode on the wireless interface (`wlan0`) using `airmon-ng`.
- It configures the interface by bringing it down, changing the MAC address with `macchanger`, and bringing it back up.

7. Packet Capture

- The script initiates packet capture using `airodump-ng` and stores the process ID (PID).

8. Deauthentication Attack

- A loop runs 200 iterations, deauthenticating clients from the target network using `aireplay-ng`. Each iteration is followed by a 5-second delay.

9. Cleanup

- The script terminates the packet capture process and performs cleanup operations.

## Disclaimer

> *"Educational Purpose Only*
>
> *This script is intended for learning and ethical testing purposes only. Any misuse or malicious use of this content is strictly prohibited and will not hold the author responsible."*

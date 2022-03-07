## WiFi DoS

### Simple wifi DoS attack with the use of:

-   [nmcli](https://developer-old.gnome.org/NetworkManager/stable/nmcli.html) - Network Manager Command Line Interface
-   [macchanger](https://en.kali.tools/?p=1404) - an utility that makes the maniputation of MAC addresses of network interfaces easier
-   [aircrack-ng](https://www.aircrack-ng.org/doku.php?id=Main) - a complete suite of tools to assess WiFi network security

### Usage

```
#change permission of the file to be executable
chmod +x wifi-dos.sh

#to see all the networks within the range of your wifi adapter
nmcli dev wifi

#need to copy the targeted SSID and the number of the channel and replace it in the script
#aircrack-ng requires sudo
sudo ./wifi-dos.sh
```

![dos](./ezgif.com-gif-maker.gif)

> #### Disclaimer:
> #### This script is for educational purpose only.
> #### Any malicious use of the content will not hold the author responsible.

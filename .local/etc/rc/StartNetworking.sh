#!/bin/zsh

WIRED_INTERFACE="ethusb[0-9]+"
WIRELESS_INTERFACE="wlo1"

# You can read sed, right?
# `ip link show` has a nice formatted output, so we just check for all the
# lines that begin with a number + colon, and use regex to extract the 
# interface name from that
interface_list=$(ip link show | \
    sed -n -E -e "/^[0-9]+:/ s/^[0-9]+: ([a-zA-Z0-9]+):.*$/\1/g p")

# Then, we need to check if the interface is in the list, using
# black magic from https://stackoverflow.com/a/8063398
if [[ $interface_list =~ (^|[[:space:]])$WIRED_INTERFACE($|[[:space:]]) ]]; then
    echo "Stopping wireless..."
    # /usr/bin/sudo /usr/bin/systemctl stop dhcpcd@${WIRELESS_INTERFACE}
    /usr/bin/sudo /usr/bin/systemctl stop wpa_supplicant@${WIRELESS_INTERFACE}
    # echo "Starting wired..."
    # /usr/bin/sudo /usr/bin/systemctl restart dhcpcd@${WIRED_INTERFACE}
else
    # echo "Stopping wired..."
    # /usr/bin/sudo /usr/bin/systemctl stop dhcpcd@${WIRED_INTERFACE}
    echo "Starting wireless..."
    /usr/bin/sudo /usr/bin/systemctl restart wpa_supplicant@${WIRELESS_INTERFACE}
    # /usr/bin/sudo /usr/bin/systemctl restart dhcpcd@${WIRELESS_INTERFACE}
fi

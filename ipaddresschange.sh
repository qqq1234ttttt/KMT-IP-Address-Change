#!/bin/bash

# -------------------------------
# 🎨 KMT CYBER LOADING
# -------------------------------
clear

text="K M T CYBER DASHBOARD BOOTING..."
len=${#text}

echo -e "\e[32m"

for ((i=0; i<=len; i++)); do
    echo -ne "\r${text:0:i}"
    sleep 0.04
done

echo -e "\n\e[0m"

echo -e "\e[31m┌───────────────────────────────────────┐\e[0m"
echo -e "\e[31m│        🔥 K M T CYBER DASHBOARD       │\e[0m"
echo -e "\e[31m│     TOR IP ROTATION CONTROL PANEL     │\e[0m"
echo -e "\e[31m└───────────────────────────────────────┘\e[0m"
echo ""

# -------------------------------
# INSTALL CHECK
# -------------------------------
pkg install tor privoxy netcat-openbsd curl -y > /dev/null 2>&1

# -------------------------------
# MENU
# -------------------------------
echo -e "\e[1;32m[1] START SYSTEM\e[0m"
echo -e "\e[1;31m[2] STOP SYSTEM\e[0m"
read -p "Select: " option

if [[ "$option" == "2" ]]; then
    pkill tor
    pkill privoxy
    echo -e "\e[1;31m[STOPPED]\e[0m"
    exit
fi

# -------------------------------
# START SERVICES
# -------------------------------
echo -e "\e[1;33m[+] Starting TOR System...\e[0m"

pkill tor
pkill privoxy
sleep 2

PORTS=(9050 9060 9070 9080 9090)
CONTROL_PORTS=(9051 9061 9071 9081 9091)

for i in {0..4}; do
    TOR_DIR="$HOME/.tor_multi/tor$i"
    mkdir -p "$TOR_DIR"

    cat <<EOF > "$TOR_DIR/torrc"
SocksPort ${PORTS[$i]}
ControlPort ${CONTROL_PORTS[$i]}
DataDirectory $TOR_DIR
CookieAuthentication 0
EOF

    tor -f "$TOR_DIR/torrc" > /dev/null 2>&1 &
    sleep 2
done

cat <<EOF > "$HOME/.privoxy/config"
listen-address 127.0.0.1:8118
EOF

for port in "${PORTS[@]}"; do
    echo "forward-socks5 / 127.0.0.1:$port ." >> "$HOME/.privoxy/config"
done

privoxy "$HOME/.privoxy/config" > /dev/null 2>&1 &

sleep 5

echo -e "\e[1;32m[✓] SYSTEM ONLINE\e[0m"

# -------------------------------
# STOP CONTROL
# -------------------------------
trap "echo -e '\n\e[1;31m[STOPPED KMT SYSTEM]\e[0m'; exit" SIGINT

# -------------------------------
# LIVE IP LOOP
# -------------------------------
ROTATION_TIME=10

while true; do

    sleep $ROTATION_TIME

    for ctrl_port in "${CONTROL_PORTS[@]}"; do
        echo -e "AUTHENTICATE \"\"\r\nSIGNAL NEWNYM\r\nQUIT" | nc 127.0.0.1 $ctrl_port > /dev/null 2>&1
    done

    sleep 3

    IP=$(curl --proxy http://127.0.0.1:8118 -s --max-time 10 https://api64.ipify.org)

    echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;36m🌐 KMT LIVE IP: $IP\e[0m"
    echo -e "\e[1;34m📡 PROXY: 127.0.0.1:8118\e[0m"
    echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"

done

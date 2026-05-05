#!/bin/bash

# -------------------------------
# 🎨 K M T LOADING LOGO
# -------------------------------

clear

text="K M T SYSTEM LOADING..."
len=${#text}

echo -e "\e[32m"

for ((i=0; i<=len; i++)); do
    echo -ne "\r${text:0:i}"
    sleep 0.05
done

echo -e "\n\e[0m"

echo -e "\e[34m┌───────────────────────────────────────┐\e[0m"
echo -e "\e[34m│        WELCOME TO K M T SYSTEM        │\e[0m"
echo -e "\e[34m└───────────────────────────────────────┘\e[0m"

echo ""

# -------------------------------
# MENU
# -------------------------------
echo -e "\e[1;32m[1] FAST MODE (1 sec loop)\e[0m"
echo -e "\e[1;32m[2] NORMAL MODE (10 sec safe)\e[0m"
read -p "Choose mode: " MODE

if [[ "$MODE" == "1" ]]; then
    ROTATION_TIME=1
else
    ROTATION_TIME=10
fi

# -------------------------------
# TOR SETUP
# -------------------------------

echo -e "\e[1;33m[+] Starting TOR Multi Node System...\e[0m"

PORTS=(9050 9060 9070 9080 9090)
CONTROL_PORTS=(9051 9061 9071 9081 9091)

pkill tor
sleep 1

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
    sleep 1
done

echo -e "\e[1;32m[✓] TOR Nodes Running...\e[0m"

# -------------------------------
# STOP CONTROL
# -------------------------------
trap "echo -e '\n\e[1;31m[STOPPED KMT SYSTEM]\e[0m'; exit" SIGINT

# -------------------------------
# MAIN LOOP (IP ROTATION)
# -------------------------------
while true; do

    for ctrl_port in "${CONTROL_PORTS[@]}"; do
        echo -e "AUTHENTICATE \"\"\r\nSIGNAL NEWNYM\r\nQUIT" | nc 127.0.0.1 $ctrl_port > /dev/null 2>&1
    done

    NEW_IP=$(curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org)

    echo -e "\e[1;36m🌐 KMT IP: $NEW_IP\e[0m"
    echo -e "\e[1;34m[Proxy] 127.0.0.1:8118\e[0m"

    sleep "$ROTATION_TIME"
done

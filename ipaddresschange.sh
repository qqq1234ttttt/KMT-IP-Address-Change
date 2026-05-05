#!/bin/bash

# -------------------------------
# 🎨 K M T LOGO (Typing Effect)
# -------------------------------
clear

text="K M T SYSTEM STARTING..."
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
# CLEAN START TOR + PROXY
# -------------------------------
echo -e "\e[1;33m[+] Restarting services...\e[0m"

pkill tor
pkill privoxy

sleep 2

# start tor
tor > /dev/null 2>&1 &

sleep 5

# start privoxy
privoxy /data/data/com.termux/files/usr/etc/privoxy/config > /dev/null 2>&1 &

sleep 5

echo -e "\e[1;32m[✓] SYSTEM READY\e[0m"

# -------------------------------
# STOP CONTROL
# -------------------------------
trap "echo -e '\n\e[1;31m[STOPPED KMT SYSTEM]\e[0m'; exit" SIGINT

# -------------------------------
# IP DISPLAY LOOP
# -------------------------------
while true; do

    IP=$(curl --proxy http://127.0.0.1:8118 -s --max-time 10 https://api64.ipify.org)

    if [[ -z "$IP" ]]; then
        echo -e "\e[1;31m🌐 KMT IP: NOT READY (Tor warming up...)\e[0m"
    else
        echo -e "\e[1;36m🌐 KMT IP: $IP\e[0m"
    fi

    echo -e "\e[1;34m[Proxy] 127.0.0.1:8118\e[0m"

    sleep 5
done

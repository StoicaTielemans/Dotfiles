#!/bin/bash

INTERVAL=1 # seconds

# Get interfaces once
interfaces=()
while IFS= read -r iface; do
  [[ $iface == lo || $iface == docker* || $iface == br-* || $iface == virbr* || $iface == tailscale* ]] && continue
  interfaces+=("$iface")
done < <(ls /sys/class/net)

# Capture first snapshot
declare -A prev_rx prev_tx
for iface in "${interfaces[@]}"; do
  read -r prev_rx[$iface] <"/sys/class/net/$iface/statistics/rx_bytes" 2>/dev/null || prev_rx[$iface]=0
  read -r prev_tx[$iface] <"/sys/class/net/$iface/statistics/tx_bytes" 2>/dev/null || prev_tx[$iface]=0
done

sleep $INTERVAL

# Capture second snapshot
declare -A up_speed down_speed
for iface in "${interfaces[@]}"; do
  read -r rx2 <"/sys/class/net/$iface/statistics/rx_bytes" 2>/dev/null || rx2=0
  read -r tx2 <"/sys/class/net/$iface/statistics/tx_bytes" 2>/dev/null || tx2=0
  rx1=${prev_rx[$iface]:-0}
  tx1=${prev_tx[$iface]:-0}
  ((down_speed[$iface] = (rx2 - rx1) / INTERVAL))
  ((up_speed[$iface] = (tx2 - tx1) / INTERVAL))
done

# Human-readable speeds
human() {
  local bytes=$1
  ((bytes < 1024)) && printf "%d B/s" "$bytes" && return
  ((bytes < 1048576)) && printf "%.1f KB/s" "$(awk -v b=$bytes 'BEGIN{print b/1024}')" && return
  printf "%.1f MB/s" "$(awk -v b=$bytes 'BEGIN{print b/1048576}')"
}

# Get all IPs and states efficiently
declare -A iface_ips iface_states
while read -r iface state ip; do
  iface_states[$iface]=$state
  iface_ips[$iface]=$ip
done < <(ip -4 -br addr show | awk '{print $1, $2, $3}' | cut -d/ -f1)

text=""
tooltip=""

for iface in "${interfaces[@]}"; do
  state="${iface_states[$iface]}"
  [[ -z $state ]] && state=$(<"/sys/class/net/$iface/operstate" 2>/dev/null || echo unknown)

  ip="${iface_ips[$iface]:-N/A}"
  mac=$(cat /sys/class/net/"$iface"/address 2>/dev/null)
  [[ -z "$mac" ]] && mac=$(ip link show "$iface" | awk '/link\/ether/ {print $2}')
  [[ -z "$mac" ]] && mac="N/A"

  up=$(human ${up_speed[$iface]})
  down=$(human ${down_speed[$iface]})

  if [[ "$state" != "UP" && "$state" != "up" ]]; then
    text="$iface down"
    tooltip+="Interface: $iface
Type: Ethernet
State: $state
IP: $ip
MAC: $mac

"
    continue
  fi

  if [[ $iface == w* ]]; then
    read -r ssid signal < <(iw dev "$iface" link 2>/dev/null | awk '/SSID/ {s=$2} /signal/ {sig=$2} END{print s, sig}')
    ssid=${ssid:-N/A}
    signal=${signal:-N/A}
    text+="↑$up ↓$down | "
    tooltip+="Interface: $iface
Type: Wi-Fi
State: $state
IP: $ip
MAC: $mac
SSID: $ssid
Signal: ${signal} dBm
TX: $up
RX: $down

"
  else
    text+="↑$up ↓$down | "
    tooltip+="Interface: $iface
Type: Ethernet
State: $state
IP: $ip
MAC: $mac
TX: $up
RX: $down

"
  fi
done

text=${text%" | "}
[[ -z "$text" ]] && text="Ethernet down"

jq -cn --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

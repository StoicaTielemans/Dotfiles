#!/bin/bash

# ----- Capture first CPU snapshot -----
declare -A prev_total prev_idle
while read -r line; do
  [[ $line =~ ^cpu[0-9]* ]] || continue
  fields=($line)
  cpu_id=${fields[0]}
  total=0
  for i in "${fields[@]:1}"; do total=$((total + i)); done
  prev_total["$cpu_id"]=$total
  prev_idle["$cpu_id"]=${fields[4]}
done </proc/stat

sleep 0.5

# ----- Capture second snapshot & calculate usage -----
declare -A usage
cpu_total_usage=0
core_count=0

while read -r line; do
  [[ $line =~ ^cpu[0-9]* ]] || continue
  fields=($line)
  cpu_id=${fields[0]}
  total=0
  for i in "${fields[@]:1}"; do total=$((total + i)); done
  diff_total=$((total - prev_total[$cpu_id]))
  diff_idle=$((fields[4] - prev_idle[$cpu_id]))
  if ((diff_total > 0)); then
    percent=$(awk -v t=$diff_total -v i=$diff_idle 'BEGIN { printf "%.1f", (t - i) / t * 100 }')
  else
    percent=0
  fi
  usage["$cpu_id"]=$percent

  # For overall CPU (line "cpu" has no number)
  if [[ $cpu_id == "cpu" ]]; then
    cpu_total_usage=$percent
  else
    ((core_count++))
  fi
done </proc/stat

# ----- CPU metadata -----
cpu_temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
cpu_freq=$(awk '/cpu MHz/ {sum+=$4; count++} END {if (count>0) printf "%.2f", sum/count/1000}' /proc/cpuinfo)
load_avg=$(awk '{print $1" "$2" "$3}' /proc/loadavg)

# ----- Memory -----
mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used_kb=$((mem_total_kb - mem_available_kb))
mem_percent=$((100 * mem_used_kb / mem_total_kb))
mem_total_gb=$(awk "BEGIN {printf \"%.2f\", $mem_total_kb/1024/1024}")
mem_used_gb=$(awk "BEGIN {printf \"%.2f\", $mem_used_kb/1024/1024}")
mem_free_gb=$(awk "BEGIN {printf \"%.2f\", $mem_available_kb/1024/1024}")

swap_total_kb=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
swap_free_kb=$(grep SwapFree /proc/meminfo | awk '{print $2}')
swap_used_kb=$((swap_total_kb - swap_free_kb))
swap_total_gb=$(awk "BEGIN {printf \"%.2f\", $swap_total_kb/1024/1024}")
swap_used_gb=$(awk "BEGIN {printf \"%.2f\", $swap_used_kb/1024/1024}")
swap_percent=$(((swap_total_kb > 0) ? (100 * swap_used_kb / swap_total_kb) : 0))

# ----- GPU -----
if command -v nvidia-smi &>/dev/null; then
  gpu_info=$(nvidia-smi --query-gpu=utilization.gpu,utilization.memory,temperature.gpu,memory.used,memory.total,fan.speed,power.draw,pstate --format=csv,noheader,nounits)
  IFS=',' read -r gpu_util gpu_mem_util gpu_temp gpu_mem_used gpu_mem_total gpu_fan gpu_power gpu_pstate <<<"$(echo $gpu_info | tr -d ' ')"
else
  gpu_util="N/A"
  gpu_mem_util="N/A"
  gpu_temp="N/A"
  gpu_mem_used="N/A"
  gpu_mem_total="N/A"
  gpu_fan="N/A"
  gpu_power="N/A"
  gpu_pstate="N/A"
fi

# ----- Per-core line -----
core_usage_text=""
for ((i = 0; i < core_count; i++)); do
  val=${usage["cpu$i"]}
  core_usage_text+="$i: ${val}%  "
  if (((i + 1) % 4 == 0)); then
    core_usage_text+=$'\n' # real newline
  fi
done

# ----- Text line -----
text="CPU ${cpu_total_usage}% ${cpu_temp}°C | GPU ${gpu_util}% ${gpu_temp}°C | MEM ${mem_percent}%"

# ----- Tooltip -----
tooltip=$(
  cat <<EOF
CPU: ${cpu_total_usage}% @ ${cpu_freq}GHz (${core_count} cores)
TEMP: ${cpu_temp}°C
LOAD AVG: ${load_avg}

CPU CORES:
${core_usage_text}

GPU (NVIDIA):
UTIL: ${gpu_util}% | MEM: ${gpu_mem_util}%
TEMP: ${gpu_temp}°C
VRAM: ${gpu_mem_used}/${gpu_mem_total} MiB
POWER: ${gpu_power}W | FAN: ${gpu_fan}%
PSTATE: ${gpu_pstate}

MEM USED: ${mem_used_gb}/${mem_total_gb} GB (${mem_percent}%)
FREE: ${mem_free_gb} GB
SWAP: ${swap_used_gb}/${swap_total_gb} GB (${swap_percent}%)
EOF
)

# ----- Output JSON -----
jq -cn --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

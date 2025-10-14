#!/bin/bash

# Read CPU fields
cpu_fields=($(grep '^cpu ' /proc/stat))
prev_idle=${cpu_fields[4]}
prev_total=0
for i in "${cpu_fields[@]:1}"; do
  prev_total=$((prev_total + i))
done

# Wait a short time
sleep 0.5

# Read again
cpu_fields=($(grep '^cpu ' /proc/stat))
idle=${cpu_fields[4]}
total=0
for i in "${cpu_fields[@]:1}"; do
  total=$((total + i))
done

# Calculate CPU usage
cpu=$((100 * ((total - prev_total) - (idle - prev_idle)) / (total - prev_total)))

# CPU temperature
cpu_temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))

# GPU usage and temp
read gpu temp <<<$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | tr -d ',')

# Memory usage %
mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used_kb=$((mem_total_kb - mem_available_kb))
mem=$((100 * mem_used_kb / mem_total_kb))

# Convert KB → GB with 2 decimals
mem_total_gb=$(awk "BEGIN {printf \"%.2f\", $mem_total_kb/1024/1024}")
mem_used_gb=$(awk "BEGIN {printf \"%.2f\", $mem_used_kb/1024/1024}")

# Print nicely
printf "CPU: %s%% %s°C | GPU: %s%% %s°C | MEM: %s%% %s GB\n" \
  "$cpu" "$cpu_temp" "$gpu" "$temp" "$mem" "$mem_used_gb"

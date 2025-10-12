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
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem=$((100 * (mem_total - mem_available) / mem_total))

# Print nicely
printf "CPU: %s%% %s°C | GPU: %s%% %s°C | MEM: %s%%\n" "$cpu" "$cpu_temp" "$gpu" "$temp" "$mem"

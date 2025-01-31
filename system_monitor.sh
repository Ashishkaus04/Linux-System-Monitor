#!/bin/bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="system_alerts.log"
CSV_FILE="system_usage.csv"

# Function to send an alert
send_alert() {
  message="ALERT: $1 usage exceeded threshold! Current value: $2%"
  echo "$(tput setaf 1)$message$(tput sgr0)"
  echo "$(date): $message" >> "$LOG_FILE"

  # Send email alert (uncomment if configured)
  # echo "$message" | mail -s "System Alert: $1 Usage High" your@email.com
}

# Initialize CSV file if not exists
if [ ! -f "$CSV_FILE" ]; then
  echo "Timestamp,CPU (%),Memory (%),Disk (%)" > "$CSV_FILE"
fi

while true; do
  # Monitor CPU
  cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')
  cpu_usage=${cpu_usage%.*}
  if ((cpu_usage >= CPU_THRESHOLD)); then
    send_alert "CPU" "$cpu_usage"
  fi

  # Monitor memory
  memory_usage=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')
  if ((memory_usage >= MEMORY_THRESHOLD)); then
    send_alert "Memory" "$memory_usage"
  fi

  # Monitor disk
  disk_usage=$(df --output=pcent / | tail -n1 | tr -dc '0-9')
  if ((disk_usage >= DISK_THRESHOLD)); then
    send_alert "Disk" "$disk_usage"
  fi

  # Log data to CSV
  echo "$(date +'%Y-%m-%d %H:%M:%S'),$cpu_usage,$memory_usage,$disk_usage" >> "$CSV_FILE"

  # Display current stats
  clear
  echo "Resource Usage:"
  echo "CPU: $cpu_usage%"
  echo "Memory: $memory_usage%"
  echo "Disk: $disk_usage%"
  echo "Logs: $(wc -l < "$LOG_FILE") alerts recorded."

  sleep 5  # Adjust the interval as needed

done

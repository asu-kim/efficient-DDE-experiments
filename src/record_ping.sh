#!/bin/bash

TARGET="10.218.100.147"
LOG_FILE="ping_log.txt"
INTERVAL=1800
DURATION=10800

SECONDS=0

while [ "$SECONDS" -lt "$DURATION" ]; do
	echo "Pinging $TARGET - $(date)" >> "$LOG_FILE"
	ping -c 25 "$TARGET" | grep "time=" | awk -F'time=' '{print $2}' | awk '{print $1" ms"}' >> "$LOG_FILE"	
	echo "Ping Completed and delay recorded at $(date)" >> "$LOG_FILE"
	echo "--------------------------------------------" >> "$LOG_FILE"

	sleep "$INTERVAL"
done
echo "Scipt completed after $DURATION seconds." | tee -a "$LOG_FILE"

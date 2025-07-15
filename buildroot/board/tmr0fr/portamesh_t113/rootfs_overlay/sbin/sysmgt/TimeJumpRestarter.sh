#!/bin/sh

# PRELIMINARY !!!
# Script for restarting certain services that don't like it when the time jumps (NTP update)

## <: TMR0.fr :>

###### CONFIG START

# Threshold (in seconds) for time jump before restart
JUMP_THRESHOLD=360000

# Interval (in seconds) between GPS activity checks
CHECK_INTERVAL=5

# Command to execute if threshold reach
RESTART_CMD="/etc/init.d/S99meshtasticd restart"

###### CONFIG END

RestartSoftware() {
	echo "Time has jumped. Restarting select services"
	$RESTART_CMD
}

GetCurrentTimestamp() {
	echo $(date +%s)
}

last_check=$(GetCurrentTimestamp)

while true
do
	curr_time=$(GetCurrentTimestamp)
	time_diff=$(($curr_time - $last_check))

	# Get absolute value of diff by removing "-" symbol...
	time_diff=${time_diff#-}

	echo "Current timestamp:" $curr_time
	echo "Difference to last timestamp:" $time_diff
	
	
	# If difference between current time and previous time more than threshold (eg: a jump occured)
	if [ $time_diff -gt $JUMP_THRESHOLD ]; then
	#	echo "Time jump occured"
		RestartSoftware
	fi
	
	# Update current timestamp
	last_check=$(GetCurrentTimestamp)

	sleep $CHECK_INTERVAL
done

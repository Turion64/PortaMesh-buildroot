#!/bin/sh

# Script for managing power state of the GNSS receiver :
# - Automatically powers on and off the GNSS receiver depending whether or not software is using it

# TODO :
# - Add inotifywait to buildroot config
# - Log messages to syslog (logger)
# - User controlled GPS power control "on/off/auto" ?

## <: TMR0.fr :>

###### CONFIG START
# GNSS device to manage
GNSS_DEV=/dev/gnss0

# Timeout (in seconds) to wait for before powering off receiver when unused
IDLE_TIMEOUT=30

# Interval (in seconds) between GPS activity checks
CHECK_INTERVAL=5

# Command to power on/enable GNSS receiver
ENABLE_CMD="gpioset 1 1=1"

# Command to power off/disable GNSS receiver
DISABLE_CMD="gpioset 1 1=0"

# Force GPSS to stay on
#FORCE_ON=0

###### CONFIG END

current_power=1
last_check=$(date +%s)
last_used=$last_check

CountFileUsers() {
	file=$1
	nb=$(lsof | grep "$file" | wc -l)
	echo $nb
}

SetGNSSPower() {
	power=$1
	# If new power state is not equal to current power state
	if [ "$power" != "$current_power" ]; then
		# if new power is "off"
		if [ "$power" = 0 ]; then
			$DISABLE_CMD
			current_power=0
		elif [ "$power" = 1 ]; then
			$ENABLE_CMD
			current_power=1
		else
			:
			#echo "Power state :" $power "unknown. Not changing power state"
			# do nothing
		fi
	fi
}

GetCurrentTimestamp() {
	echo $(date +%s)
}

while true
do
	# "Mesure" of how many clients are using the GNSS
	nb_gnss_clients=$(CountFileUsers $GNSS_DEV)
	last_check=$(GetCurrentTimestamp)
	#echo "Current GNSS users :" $nb_gnss_clients
	
	# If we have more than one users, save timestamp
	if [ $nb_gnss_clients -gt 0 ]; then
		last_used=$(GetCurrentTimestamp)
	#	echo "GNSS in use..."
	fi
	
	#echo "Current timestamp" $(GetCurrentTimestamp)
	#echo "Last use + timout" $(($last_used + $IDLE_TIMEOUT))
	
	
	# If GNSS has been unused for more than set timeout, disable it
	if [ $(GetCurrentTimestamp) -gt $(($last_used + $IDLE_TIMEOUT)) ]; then
	#	echo "GNSS unused for more than" $IDLE_TIMEOUT "seconds. Disabling."
		SetGNSSPower "0"
	else
	#	echo "GNSS in use. Powering up"
		SetGNSSPower "1"
	fi
	
	sleep $CHECK_INTERVAL
	# Check for device open event. If it does not occurs within -t timetout, it returns 3? If event occurs, returns 0
	# This allows for very long check interval without ignoring short periodic device access
	#inotifywait -e open -qq $GNSS_DEV -t $CHECK_INTERVAL
	# if status == 0 (event happened), continue. Bash really is a retarded language
	#if [ "$?" = 0 ] ; then
	#	last_used=$(GetCurrentTimestamp)
		#sleep $((
	#fi
done

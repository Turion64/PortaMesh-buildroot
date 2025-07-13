#!/bin/sh
export DISPLAY=:0
pulseaudio --start --log-target=syslog --disallow-exit --exit-idle-time=-1


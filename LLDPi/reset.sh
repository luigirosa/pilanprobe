#!/bin/bash

set -m
killall /usr/bin/python3 /home/pi/LLDPi/LLDPiGUI.py
/home/pi/LLDPi/LLDPiGUI.py &
#npid=$!
set +m

#sudo kill -TERM -- -$1

exit 0

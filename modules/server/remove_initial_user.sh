#!/bin/sh
set -x
set -e
# wait for previous connection to close
sleep 2
sudo killall -TERM -u "${INITIAL_USER}"
# wait for killall to finish
sleep 2 
sudo userdel -r "${INITIAL_USER}"

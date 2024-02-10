#!/bin/env bash
set -x
set -e
# this script will update a SLES-15 server
zypper update -y
zypper dup -y
zypper update -y

# reboot in 20 seconds and exit this script
# this allows us to reboot without Terraform receiving errors
# WARNING: there is careful timing here, the reboot must happen before Terraform reconnects for the next script, but give enough time for cloud-init to finish
( sleep 20 ; reboot ) & 
exit 0
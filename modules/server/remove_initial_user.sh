#!/bin/sh
set -x
set -e
INITIAL_USER="${1}"
if [ -z "${INITIAL_USER}" ]; then
  echo "INITIAL_USER is not set"
  exit 1
fi

# wait for previous connection to close
sleep 2
killall -TERM -u "${INITIAL_USER}" 2> error.log || true
ERR="$(cat error.log)"
case $ERR in
  "")
    echo "No error found"
    ;;
  *"Cannot find user"*)
    echo "User not found, ignoring error"
    ;;
  *)
    cat error.log
    exit 1
    ;;
esac

# wait for killall to finish
sleep 2 
userdel -r "${INITIAL_USER}" 2> error.log || true
ERR="$(cat error.log)"
case $ERR in
  "")
    echo "No error found"
    ;;
  *"does not exist"*)
    echo "User not found, ignoring error"
    ;;
  *"no crontab for"*)
    echo "User not found, ignoring error"
    ;;
  *"not found"*)
    echo "User not found, ignoring error"
    ;;
  *)
    cat error.log
    exit 1
    ;;
esac

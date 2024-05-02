#!/bin/sh
set -x
set -e
INITIAL_USER="${1}"
if [ -z "${INITIAL_USER}" ]; then
  echo "INITIAL_USER is not set"
  exit 1
fi

kill_all() {
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
}
p_kill() {
  pkill -u "${INITIAL_USER}" 2> error.log || true
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
}
p_s() {
  ps -u "${INITIAL_USER}" -o pid | xargs kill -9 2> error.log || true
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
}

sleep 2 # wait for previous connection to close
if [ -n "$(which killall)" ]; then kill_all;
elif [ -n "$(which pkill)" ]; then p_kill;
else p_s;
fi

sleep 2 # wait for killall to finish
userdel -f -r "${INITIAL_USER}" 2> error.log || true
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

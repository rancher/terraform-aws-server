#!/bin/sh
# script assumes run by sudoer
set -x
set -e
INITIAL_USER="${1}"
USER="${2}"
NAME="${3}"
ADMIN_GROUP="${4}"
TIMEOUT="${5}" # this is the timeout in minutes to wait for cloud-init
IGNORE_CLOUDINIT="${6}"

if [ -z "${INITIAL_USER}" ]; then echo "INITIAL_USER is not set"; exit 1; fi
if [ -z "${USER}" ]; then echo "USER is not set"; exit 1; fi
if [ -z "${NAME}" ]; then echo "NAME is not set"; exit 1; fi
if [ -z "${ADMIN_GROUP}" ]; then echo "ADMIN_GROUP is not set"; exit 1; fi
# default timeout to 5min
if [ -z "${TIMEOUT}" ]; then TIMEOUT=5; fi
if [ -z "${IGNORE_CLOUDINIT}" ]; then IGNORE_CLOUDINIT=0; fi
if [ -z "$(which cloud-init)" ]; then IGNORE_CLOUDINIT=1; fi
if [ "${IGNORE_CLOUDINIT}" = "false" ]; then IGNORE_CLOUDINIT=0; fi
if [ "${IGNORE_CLOUDINIT}" = "true" ]; then IGNORE_CLOUDINIT=1; fi

EXIT=0
max_attempts=$((TIMEOUT * 60 / 10))
attempts=0
interval=10

if [ "${IGNORE_CLOUDINIT}" -eq 1 ]; then
  echo "cloud-init not found or ignored, attempting other tools...";
  # check for user, if it doesn't exist generate it
  if [ "$(awk -F: '{ print $1 }' /etc/passwd | grep "${USER}")" = "" ]; then
    if [ "$(which addgroup)" != "" ]; then
        addgroup "${USER}" # generate a group for the user
        adduser  --ingroup "${USER}" --shell "/bin/sh" --disabled-password --gecos "${USER}" "${USER}"
        adduser  "${USER}" "${ADMIN_GROUP}"
    elif [ "$(which useradd)" != "" ]; then
        useradd -U -s "/bin/sh" -m -G "${ADMIN_GROUP}" "${USER}"
        echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    else {
        echo "No supported user creation tool found";
        EXIT=1
        break
    }
    fi
    install -d -m 0700 /home/"${USER}"/.ssh
    cp .ssh/authorized_keys /home/"${USER}"/.ssh
    chown -R "${USER}":"${USER}" /home/"${USER}"
    passwd -d "${USER}"
  fi
else
  while [ "$(cloud-init status)" != "status: done" ]; do
    if [ "$(cloud-init status)" = "status: error" ]; then
      EXIT=1
      echo "cloud-init is errored..."
      echo "instance data: "
      cat /var/lib/cloud/instance/cloud-config.txt
      echo "failed script: "
      cat /var/lib/cloud/instance/scripts/config.sh
      echo "log: "
      cat /var/log/cloud-init.log
      break
    fi
    echo "cloud init is \"$(cloud-init status)\""
    attempts=$((attempts + 1))
    if [ ${attempts} = ${max_attempts} ]; then EXIT=1; break; fi
    sleep ${interval};
  done
  echo "cloud init is \"$(cloud-init status)\""
fi

# we need to make sure the hostname is set properly if possible
if [ "$(which hostnamectl)" = "" ]; then
  echo "hostnamectl not found";
else
  hostnamectl set-hostname "${NAME}"
fi

# some images set sshd config to only allow initial user to connect (CIS)
# add our user to the list of allowed users and restart sshd
if [ "${INITIAL_USER}" != "${USER}" ]; then
  sed -i 's/^AllowUsers.*/& '"${USER}"'/' /etc/ssh/sshd_config
  systemctl restart sshd || true
  systemctl restart ssh || true # ubuntu 24.04...>:(
fi

exit $EXIT

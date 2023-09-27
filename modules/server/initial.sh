#!/bin/sh
set -x
set -e
if [ "$(which cloud-init)" = "" ]; then
  echo "cloud-init not found";
  # check for user, if it doesn't exist generate it
  if [ "$(awk -F: '{ print $1 }' /etc/passwd | grep "${USER}")" = "" ]; then
    sudo addgroup "${USER}"
    sudo adduser -g "${USER}" -s "/bin/sh" -G "${USER}" -D "${USER}"
    sudo addgroup "${USER}" "${ADMIN_GROUP}"
    sudo install -d -m 0700 /home/"${USER}"/.ssh
    sudo cp .ssh/authorized_keys /home/"${USER}"/.ssh
    sudo chown -R "${USER}":"${USER}" /home/"${USER}"
    sudo passwd -d "${USER}"
  fi
  exit 0;
fi

max_attempts=20
attempts=0
interval=10
while [ "$(sudo cloud-init status)" != "status: done" ]; do
  echo "cloud init is \"$(sudo cloud-init status)\""
  attempts=$((attempts + 1))
  if [ ${attempts} = ${max_attempts} ]; then break; fi
  sleep ${interval};
done
echo "cloud init is \"$(sudo cloud-init status)\""

# some images set sshd config to only allow initial user to connect (CIS)
# add our user to the list of allowed users and restart sshd
if [ "${INITIAL_USER}" != "${USER}" ]; then
  sudo sed -i 's/^AllowUsers.*/& '"${USER}"'/' /etc/ssh/sshd_config
  sudo systemctl restart sshd
fi
# we need to make sure the hostname is set properly if possible
if [ "$(which hostnamectl)" = "" ]; then
  echo "hostnamectl not found";
else
  sudo hostnamectl set-hostname "${NAME}"
fi
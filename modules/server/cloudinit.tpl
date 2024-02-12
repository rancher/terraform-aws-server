#cloud-config
users:
  - name: ${initial_user}
    gecos: ${initial_user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, ${admin_group}
    lock_passwd: true
%{ if ssh_key != "" ~}
    ssh_authorized_keys:
      - ${ssh_key}
%{ endif ~}
    homedir: /home/${initial_user}
  - name: ${user}
    gecos: ${user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, ${admin_group}
    lock_passwd: true
%{ if ssh_key != "" ~}
    ssh_authorized_keys:
      - ${ssh_key}
%{ endif ~}
    homedir: /home/${user}
fqdn: ${name}
%{ if script != "" ~}
runcmd:
  - "/bin/env bash -c /var/tmp/init.sh"
write_files:
  - path: /var/tmp/init.sh
    content: |
      ${script}
    owner: 'root:root'
    permissions: '0755'
%{ endif ~}
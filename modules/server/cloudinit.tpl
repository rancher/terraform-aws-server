#cloud-config
users:
  - name: ${initial_user}
    gecos: ${initial_user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, ${admin_group}
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_key}
  - name: ${user}
    gecos: ${user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, ${admin_group}
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_key}
fqdn: ${name}
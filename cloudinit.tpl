#cloud-config
merge_how:
 - name: list
   settings: [replace]
 - name: dict
   settings: [replace]
# strings are replace by default

users:
  - name: ${user}
    gecos: ${user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, ${admin_group}
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_key}
    homedir: /home/${user}
fqdn: ${name}
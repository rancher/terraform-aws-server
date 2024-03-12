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
runcmd:
  - chmod +x /var/lib/cloud/instance/scripts/config.sh
  - chmod 0755 /var/lib/cloud/instance/scripts/config.sh
  - echo "ami is ${ami}"
  - echo "public_ip is ${eip}"
  - echo "subnet id is ${subnet}"
  - echo "az it ${az}"

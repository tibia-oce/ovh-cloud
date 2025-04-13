#!/usr/bin/env bash
#
# This script prompts the user for server information
# and writes the results to src/ansible/inventory/hosts.yml

set -e
trap "exit 130" INT

read -p "VPS Name (descriptive only, e.g. ovh-vps): " vps_name
read -p "Server IP/Hostname (e.g. 123.45.67.89): " server_ip
read -p "SSH Username (e.g. root): " ssh_user
read -p "SSH Password (leave blank if using keys): " ssh_pass

# Create the hosts file
cat <<EOF > src/ansible/inventory/hosts.yml
---
all:
  hosts:
    tibia_server:
      vps_name: ${vps_name}
      ansible_host: ${server_ip}
      ansible_user: ${ssh_user}
EOF

# Only include ansible_password if the user typed something
if [[ -n "${ssh_pass}" ]]; then
  echo "      ansible_password: ${ssh_pass}" >> src/ansible/inventory/hosts.yml
fi

cat <<EOF >> src/ansible/inventory/hosts.yml
      deploy_user: deploy
EOF

#!/usr/bin/env bash
#
# This script prompts the user for server information and various service credentials,
# then writes the results to src/ansible/inventory/hosts.yml.
#
# It collects credentials for:
#   - SSH (for VPS access) – ansible_password is mandatory.
#   - Deploy (non-root) user credentials – these serve as defaults for all other services.
#   - MySQL/MariaDB, Traefik, and phpMyAdmin credentials default to the deploy user's values.
#
# Since the hosts.yml file isn't tracked in Git, it's safe to store these credentials there.

set -e
trap "exit 130" INT

INVENTORY="src/ansible/inventory/hosts.yml"

# ----- Basic VPS Information -----
# Default VPS name: tibia-vps
read -p "🏷 VPS Name (default: tibia-vps): " vps_name
vps_name=${vps_name:-tibia-vps}

# Server IP/Hostname (ansible_host) - required
while true; do
  read -p "🌐 Server IP/Hostname (e.g. 123.45.67.89): " server_ip
  if [[ -n "$server_ip" ]]; then
    break
  else
    echo "❌ Server IP/Hostname cannot be empty. Please enter a valid value."
  fi
done

# SSH username - required
while true; do
  read -p "👤 SSH Username (e.g. ubuntu): " ssh_user
  if [[ -n "$ssh_user" ]]; then
    break
  else
    echo "❌ SSH Username cannot be empty. Please enter a valid value."
  fi
done

# SSH password (ansible_password) - required
while true; do
  read -s -p "🔑 SSH Password (required, leave blank not allowed): " ssh_pass
  echo ""
  if [[ -n "$ssh_pass" ]]; then
    break
  else
    echo "❌ SSH Password cannot be empty. Please enter a valid password."
  fi
done

# ----- Deploy (non-root) User Credentials -----
# These credentials will be used as the defaults for MySQL, Traefik, and phpMyAdmin.
read -p "🧑‍💻 Deploy Username (default: admin): " deploy_user
deploy_user=${deploy_user:-admin}
while true; do
  read -s -p "🧑‍💻 Deploy User Password (required): " deploy_pass
  echo ""
  if [[ -n "$deploy_pass" ]]; then
    break
  else
    echo "❌ Deploy User Password cannot be empty. Please enter a valid password."
  fi
done

# For the following service credentials, if the user leaves the field empty,
# the deploy credentials will be used as the default.

default_pass_display="${deploy_pass:0:4}******"
# ----- MySQL/MariaDB Credentials -----
read -p "🗄 MySQL Username (default: ${deploy_user}): " mysql_user
mysql_user=${mysql_user:-$deploy_user}
read -s -p "🗄 MySQL Password (default: ${default_pass_display}): " mysql_pass
echo ""
mysql_pass=${mysql_pass:-$deploy_pass}

# ----- Traefik Credentials -----
read -p "🌀 Traefik Username (default: ${deploy_user}): " traefik_user
traefik_user=${traefik_user:-$deploy_user}
# Prepare masked default for Traefik password based on deploy_pass
read -s -p "🌀 Traefik Password (default: ${default_pass_display}): " traefik_pass
echo ""
traefik_pass=${traefik_pass:-$deploy_pass}

# ----- phpMyAdmin Credentials -----
read -p "🛠 phpMyAdmin Username (default: ${deploy_user}): " phpmyadmin_user
phpmyadmin_user=${phpmyadmin_user:-$deploy_user}
read -s -p "🛠 phpMyAdmin Password (default: ${default_pass_display}):: " phpmyadmin_pass
echo ""
phpmyadmin_pass=${phpmyadmin_pass:-$deploy_pass}

# ----- Write the Inventory File -----
cat <<EOF > "$INVENTORY"
---
all:
  hosts:
    tibia_server:
      vps_name: ${vps_name}
      ansible_host: ${server_ip}
      ansible_user: ${ssh_user}
      ansible_password: ${ssh_pass}
EOF

cat <<EOF >> "$INVENTORY"
      deploy_user: ${deploy_user}
      deploy_password: ${deploy_pass}
      mysql_user: ${mysql_user}
      mysql_pass: ${mysql_pass}
      traefik_user: ${traefik_user}
      traefik_pass: ${traefik_pass}
      phpmyadmin_user: ${phpmyadmin_user}
      phpmyadmin_pass: ${phpmyadmin_pass}
EOF

echo "✅ Inventory file '$INVENTORY' has been created/updated."

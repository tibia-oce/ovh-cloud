#!/usr/bin/env bash
#
# This script prompts the user for server information and various service credentials,
# then writes the results to src/ansible/inventory/hosts.yml.
#
# When updating an existing file, the current values (if available) are shown as defaults.
#
# It collects credentials for:
#   - SSH (for VPS access) – ansible_password is mandatory.
#   - Deploy (non-root) user credentials – these serve as defaults for all other services.
#   - MySQL/MariaDB, Traefik, and phpMyAdmin credentials default to the deploy user's values.
#   - Optionally, Cloudflare credentials (Account Email, API Token, and Domain).
#
# Since the hosts.yml file isn't tracked in Git, it's safe to store these credentials there.

set -e
trap "exit 130" INT

INVENTORY="src/ansible/inventory/hosts.yml"

# Function to mask passwords (shows first 4 characters)
mask() {
  if [ -n "$1" ]; then
    echo "${1:0:4}******"
  else
    echo ""
  fi
}

# ----- Load Existing Values if the Inventory File Exists -----
if [ -f "$INVENTORY" ]; then
  existing_vps_name=$(grep 'vps_name:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_ansible_host=$(grep 'ansible_host:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_ssh_user=$(grep 'ansible_user:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_ssh_pass=$(grep 'ansible_password:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_deploy_user=$(grep 'deploy_user:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_deploy_pass=$(grep 'deploy_password:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_mysql_user=$(grep 'mysql_user:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_mysql_pass=$(grep 'mysql_pass:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_traefik_user=$(grep 'traefik_user:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_traefik_pass=$(grep 'traefik_pass:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_phpmyadmin_user=$(grep 'phpmyadmin_user:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_phpmyadmin_pass=$(grep 'phpmyadmin_pass:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_cloudflare_setup=$(grep 'cloudflare_setup:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_cloudflare_account_email=$(grep 'cloudflare_account_email:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_cloudflare_api_token=$(grep 'cloudflare_api_token:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
  existing_cloudflare_domain=$(grep 'cloudflare_domain:' "$INVENTORY" | head -n1 | awk -F': ' '{print $2}')
fi

# ----- Basic VPS Information -----
# VPS Name
read -p "🏷 VPS Name (default: ${existing_vps_name:-tibia-vps}): " vps_name_input
vps_name=${vps_name_input:-${existing_vps_name:-tibia-vps}}

# Server IP/Hostname (ansible_host) - required
while true; do
  read -p "🌐 Server IP/Hostname (existing: ${existing_ansible_host:-none}): " server_ip_input
  server_ip=${server_ip_input:-$existing_ansible_host}
  if [[ -n "$server_ip" ]]; then
    break
  else
    echo "❌ Server IP/Hostname cannot be empty. Please enter a valid value."
  fi
done

# SSH username - required
while true; do
  read -p "👤 SSH Username (existing: ${existing_ssh_user:-none}): " ssh_user_input
  ssh_user=${ssh_user_input:-$existing_ssh_user}
  if [[ -n "$ssh_user" ]]; then
    break
  else
    echo "❌ SSH Username cannot be empty. Please enter a valid value."
  fi
done

# SSH password (ansible_password) - required
while true; do
  prompt="🔑 SSH Password (required"
  if [[ -n "$existing_ssh_pass" ]]; then
    prompt+=", existing: $(mask "$existing_ssh_pass")"
  fi
  prompt+="): "
  read -s -p "$prompt" ssh_pass_input
  echo ""
  ssh_pass=${ssh_pass_input:-$existing_ssh_pass}
  if [[ -n "$ssh_pass" ]]; then
    break
  else
    echo "❌ SSH Password cannot be empty. Please enter a valid password."
  fi
done

# ----- Deploy (non-root) User Credentials -----
# Deploy Username
read -p "🧑‍💻 Deploy Username (existing: ${existing_deploy_user:-admin}): " deploy_user_input
deploy_user=${deploy_user_input:-${existing_deploy_user:-admin}}

# Deploy Password
while true; do
  prompt="🧑‍💻 Deploy User Password (required"
  if [[ -n "$existing_deploy_pass" ]]; then
    prompt+=", existing: $(mask "$existing_deploy_pass")"
  fi
  prompt+="): "
  read -s -p "$prompt" deploy_pass_input
  echo ""
  deploy_pass=${deploy_pass_input:-$existing_deploy_pass}
  if [[ -n "$deploy_pass" ]]; then
    break
  else
    echo "❌ Deploy User Password cannot be empty. Please enter a valid password."
  fi
done

# ----- MySQL/MariaDB Credentials -----
read -p "🗄 MySQL Username (existing: ${existing_mysql_user:-$deploy_user}): " mysql_user_input
mysql_user=${mysql_user_input:-${existing_mysql_user:-$deploy_user}}

while true; do
  prompt="🗄 MySQL Password (required"
  if [[ -n "$existing_mysql_pass" ]]; then
    prompt+=", existing: $(mask "$existing_mysql_pass")"
  else
    prompt+=", default: $(mask "$deploy_pass")"
  fi
  prompt+="): "
  read -s -p "$prompt" mysql_pass_input
  echo ""
  mysql_pass=${mysql_pass_input:-${existing_mysql_pass:-$deploy_pass}}
  if [[ -n "$mysql_pass" ]]; then
    break
  else
    echo "❌ MySQL Password cannot be empty. Please enter a valid password."
  fi
done

# ----- Traefik Credentials -----
read -p "🌀 Traefik Username (existing: ${existing_traefik_user:-$deploy_user}): " traefik_user_input
traefik_user=${traefik_user_input:-${existing_traefik_user:-$deploy_user}}

while true; do
  prompt="🌀 Traefik Password (required"
  if [[ -n "$existing_traefik_pass" ]]; then
    prompt+=", existing: $(mask "$existing_traefik_pass")"
  else
    prompt+=", default: $(mask "$deploy_pass")"
  fi
  prompt+="): "
  read -s -p "$prompt" traefik_pass_input
  echo ""
  traefik_pass=${traefik_pass_input:-${existing_traefik_pass:-$deploy_pass}}
  if [[ -n "$traefik_pass" ]]; then
    break
  else
    echo "❌ Traefik Password cannot be empty. Please enter a valid password."
  fi
done

# ----- phpMyAdmin Credentials -----
read -p "🛠 phpMyAdmin Username (existing: ${existing_phpmyadmin_user:-$deploy_user}): " phpmyadmin_user_input
phpmyadmin_user=${phpmyadmin_user_input:-${existing_phpmyadmin_user:-$deploy_user}}

while true; do
  prompt="🛠 phpMyAdmin Password (required"
  if [[ -n "$existing_phpmyadmin_pass" ]]; then
    prompt+=", existing: $(mask "$existing_phpmyadmin_pass")"
  else
    prompt+=", default: $(mask "$deploy_pass")"
  fi
  prompt+="): "
  read -s -p "$prompt" phpmyadmin_pass_input
  echo ""
  phpmyadmin_pass=${phpmyadmin_pass_input:-${existing_phpmyadmin_pass:-$deploy_pass}}
  if [[ -n "$phpmyadmin_pass" ]]; then
    break
  else
    echo "❌ phpMyAdmin Password cannot be empty. Please enter a valid password."
  fi
done

# ----- Cloudflare Setup -----
cf_default=${existing_cloudflare_setup:-no}
read -p "☁️ Set up Cloudflare? (yes/no, default: ${cf_default}): " cf_setup_input
cf_setup=${cf_setup_input:-$cf_default}

if [[ "$cf_setup" =~ ^([yY][eE][sS]|[yY]|true)$ ]]; then
  # Cloudflare Account Email - required
  while true; do
    read -p "☁️ Cloudflare Account Email (existing: ${existing_cloudflare_account_email:-none}): " cf_account_email_input
    cloudflare_account_email=${cf_account_email_input:-$existing_cloudflare_account_email}
    if [[ -n "$cloudflare_account_email" ]]; then
      break
    else
      echo "❌ Cloudflare Account Email cannot be empty. Please enter a valid value."
    fi
  done

  # Cloudflare API token - required
  while true; do
    prompt="☁️ Cloudflare API Token (required"
    if [[ -n "$existing_cloudflare_api_token" ]]; then
      prompt+=", existing: $(mask "$existing_cloudflare_api_token")"
    fi
    prompt+="): "
    read -p "$prompt" cf_token_input
    echo ""
    cloudflare_api_token=${cf_token_input:-$existing_cloudflare_api_token}
    if [[ -n "$cloudflare_api_token" ]]; then
      break
    else
      echo "❌ Cloudflare API Token cannot be empty. Please enter a valid token."
    fi
  done

  # Cloudflare Domain Name - required
  while true; do
    read -p "☁️ Cloudflare Domain Name (existing: ${existing_cloudflare_domain:-none}, e.g. google.com): " cf_domain_input
    cloudflare_domain=${cf_domain_input:-$existing_cloudflare_domain}
    if [[ -n "$cloudflare_domain" ]]; then
      break
    else
      echo "❌ Cloudflare Domain Name cannot be empty. Please enter a valid domain (e.g. google.com)."
    fi
  done
fi

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

if [[ "$cf_setup" =~ ^([yY][eE][sS]|[yY]|true)$ ]]; then
cat <<EOF >> "$INVENTORY"
      cloudflare_setup: true
      cloudflare_account_email: ${cloudflare_account_email}
      cloudflare_api_token: ${cloudflare_api_token}
      cloudflare_domain: ${cloudflare_domain}
EOF
else
cat <<EOF >> "$INVENTORY"
      cloudflare_setup: false
EOF
fi

echo "✅ Inventory file '$INVENTORY' has been created/updated."

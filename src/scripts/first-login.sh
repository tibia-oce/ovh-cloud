#!/usr/bin/env bash

set -e
trap "exit 130" INT

INVENTORY="src/ansible/inventory/hosts.yml"

host=$(awk '/ansible_host:/ { print $2; exit }' "$INVENTORY")
user=$(awk '/ansible_user:/ { print $2; exit }' "$INVENTORY")

if [ -z "$host" ] || [ -z "$user" ]; then
  echo "❌ Unable to extract 'ansible_host' or 'ansible_user' from $INVENTORY"
  exit 1
fi

echo "🔐 A one-time manual SSH login is required to cache the password and register the host."
echo "This will open an SSH connection to: $user@$host"
echo
read -p "Are you ready to log in and enter the password now? (y/n): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "➡️ Connecting to $user@$host..."
  ssh "$user@$host"
else
  echo "ℹ️ Skipping manual login for now. You can run 'just first-login' later."
fi

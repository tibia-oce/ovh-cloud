#!/usr/bin/env bash

set -e
trap "exit 130" INT

INVENTORY="src/ansible/inventory/hosts.yml"
KNOWN_HOSTS="$HOME/.ssh/known_hosts"

mkdir -p "$(dirname "$KNOWN_HOSTS")"

# Extract the first host and user from the inventory
host=$(awk '/ansible_host:/ { print $2; exit }' "$INVENTORY")
user=$(awk '/ansible_user:/ { print $2; exit }' "$INVENTORY")

if [ -z "$host" ] || [ -z "$user" ]; then
  echo "❌ Could not extract ansible_host or ansible_user from $INVENTORY"
  exit 1
fi

# Check if the host is already in known_hosts
if ssh-keygen -F "$host" > /dev/null; then
  echo "✅ SSH host '$host' already trusted (found in known_hosts)."
else
  echo "🔐 Adding $host to known_hosts..."
  ssh-keyscan -H "$host" >> "$KNOWN_HOSTS"
  echo "✅ SSH host '$host' added to known_hosts."
fi

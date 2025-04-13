#!/usr/bin/env bash

set -e
trap "exit 130" INT

SSH_DIR="$HOME/.ssh"
KEYS_DIR="src/ansible/keys"
DEFAULT_KEY_NAME="vps_tibia_server"

mkdir -p "$KEYS_DIR"

echo "🔑 SSH Key Setup"
echo "Would you like to:"
echo "  [1] Generate a new SSH key"
echo "  [2] Select an existing key from ~/.ssh"
read -p "Enter selection [1 or 2]: " key_choice

if [ "$key_choice" = "1" ]; then
  # Obtain vps_name from inventory or prompt user
  if [ -f "src/ansible/inventory/hosts.yml" ]; then
    vps_name="$(awk '/vps_name:/ {print $2}' src/ansible/inventory/hosts.yml | head -n1)"
  fi
  if [ -z "$vps_name" ]; then
    echo "No 'vps_name' found in inventory (or no inventory file)."
    read -p "Enter a name for your new key [default: $DEFAULT_KEY_NAME]: " user_input
    vps_name="${user_input:-$DEFAULT_KEY_NAME}"
  fi

  PRIVATE_KEY="$SSH_DIR/$vps_name"
  PUBLIC_KEY="$SSH_DIR/$vps_name.pub"
  PUB_DEST="$KEYS_DIR/$vps_name.pub"

  # Check for existing keys
  if [ -e "$PRIVATE_KEY" ] || [ -e "$PUBLIC_KEY" ]; then
    echo "⚠️  A key named '$vps_name' already exists in ~/.ssh."
    read -p "Would you like to use the existing key? (y/n): " use_existing
    if [[ "$use_existing" =~ ^[Yy]$ ]]; then
      if [ -e "$PUB_DEST" ]; then
        echo "✅ Public key already exists at: $PUB_DEST"
      else
        cp "$PUBLIC_KEY" "$PUB_DEST"
        echo "✅ Existing public key copied to: $PUB_DEST"
      fi
      exit 0
    else
      echo "❌ Please manually handle or remove existing key files before continuing."
      exit 1
    fi
  fi

  if [ -e "$PUB_DEST" ]; then
    echo "❌ ERROR: Public key already exists at $PUB_DEST."
    exit 1
  fi

  # Generate new SSH key
  ssh-keygen -t ed25519 -f "$PRIVATE_KEY" -N "" -C "$vps_name"
  echo "✅ Private key generated at: $PRIVATE_KEY"
  cp "$PUBLIC_KEY" "$PUB_DEST"
  echo "✅ Public key copied to: $PUB_DEST"

elif [ "$key_choice" = "2" ]; then
  # List available keys
  available_keys=$(find "$SSH_DIR" -maxdepth 1 -type f -name '*.pub' -exec basename {} .pub \;)
  if [ -z "$available_keys" ]; then
    echo "❌ ERROR: No public keys (*.pub) found in $SSH_DIR."
    exit 1
  fi

  echo "🔑 Available SSH public keys:"
  select selected_key in $available_keys; do
    if [ -n "$selected_key" ]; then
      PUB_DEST="$KEYS_DIR/$selected_key.pub"
      if [ -e "$PUB_DEST" ]; then
        echo "✅ Public key '$selected_key.pub' already exists in $KEYS_DIR."
      else
        cp "$SSH_DIR/$selected_key.pub" "$PUB_DEST"
        echo "✅ Public key '$selected_key.pub' copied to: $PUB_DEST"
      fi
      break
    else
      echo "❌ Invalid selection. Try again."
    fi
  done

else
  echo "❌ Invalid selection. Please run again."
  exit 1
fi

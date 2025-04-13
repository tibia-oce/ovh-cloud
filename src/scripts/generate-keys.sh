#!/usr/bin/env bash
#
# Generates a new SSH key pair named after the 'vps_name' in inventory,
# or a fallback if not found. The private key is stored in ~/.ssh/<vps_name>,
# and the public key is copied into src/ansible/keys/<vps_name>.pub.
#
# NEVER overwrites existing keys.

set -e
trap "exit 130" INT

DEFAULT_NAME="vps_tibia_server"
SSH_DIR="$HOME/.ssh"
KEYS_DIR="src/ansible/keys"

mkdir -p "$SSH_DIR"
mkdir -p "$KEYS_DIR"

# Attempt to parse `vps_name:` from hosts.yml
if [ -f "src/ansible/inventory/hosts.yml" ]; then
  vps_name="$(awk '/vps_name:/ {print $2}' src/ansible/inventory/hosts.yml | head -n1)"
fi

# If no vps_name found, prompt user for fallback
if [ -z "$vps_name" ]; then
  echo "No 'vps_name' found in inventory (or no inventory file)."
  read -p "Enter a name for your new key [default: $DEFAULT_NAME]: " user_input
  vps_name="${user_input:-$DEFAULT_NAME}"
fi

PRIVATE_KEY="$SSH_DIR/$vps_name"
PUBLIC_KEY="$SSH_DIR/$vps_name.pub"
PUB_DEST="$KEYS_DIR/$vps_name.pub"

echo "Preparing to generate a key named '$vps_name' in $SSH_DIR..."

# Check if either file already exists in ~/.ssh
if [ -e "$PRIVATE_KEY" ] || [ -e "$PUBLIC_KEY" ]; then
  echo "ERROR: The key file '$PRIVATE_KEY' or '$PUBLIC_KEY' already exists."
  echo "Refusing to overwrite. Please remove them or choose a different name."
  exit 1
fi

# Check if the public key already exists in src/ansible/keys
if [ -e "$PUB_DEST" ]; then
  echo "ERROR: The public key file '$PUB_DEST' already exists in the repo."
  echo "Refusing to overwrite. Please remove it or choose a different name."
  exit 1
fi

# Generate the key pair (using ed25519, no passphrase).
ssh-keygen -t ed25519 -f "$PRIVATE_KEY" -N "" -C "$vps_name"
echo "Private key generated at: $PRIVATE_KEY"
echo "Public key generated at:  $PUBLIC_KEY"

# Copy the public key to src/ansible/keys/<vps_name>.pub
cp "$PUBLIC_KEY" "$PUB_DEST"
echo "Public key copied to: $PUB_DEST"

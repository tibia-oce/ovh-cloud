# SSH Public Keys

This directory contains YOUR public SSH keys used for server access.

Ensure only the .pub keys in this directory belong to users you want to provide SSH access to.

- Add your public keys (`.pub` files) to this directory.
- Keys will be added to authorized_keys for admin and deploy users
- Only public keys should be stored here (never private keys)

Common key locations:
- `~/.ssh/id_rsa.pub`
- `~/.ssh/id_ed25519.pub`

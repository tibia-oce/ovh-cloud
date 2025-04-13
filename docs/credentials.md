# OVH Credentials Guide

This guide explains how to properly handle credentials after setting up a VPS on OVHCloud.

## Initial Credentials

After provisioning a VPS with OVH, you'll receive:
- Server IP address
- Root username
- Initial root password
- SSH key (if you provided one during setup)

## Handling Your Credentials

1. **Store securely**: Save your initial credentials in a password manager
2. **IP Address**: Add to your `inventory/hosts.yml` file under `ansible_host`
3. **Root Username**: Set as `ansible_user` in your inventory (typically "root")
4. **Password**: Use only for initial login, then disable password authentication
5. **SSH Keys**: If OVH generated a key for you:
   - Download the private key
   - Store it securely (e.g., in your `~/.ssh/` directory)
   - Set appropriate permissions: `chmod 600 ~/.ssh/your_key`

## First-Time Login

Verify SSH access to your server:
```
ssh root@your_server_ip
```

If using a custom private key:
```
ssh -i ~/.ssh/your_key root@your_server_ip
```

## Next Steps

After verifying access:
1. Run the bootstrap playbook to secure your server
2. The playbook will disable root login and password authentication
3. Further access will be through the admin user with SSH keys only

## Security Note

The bootstrap playbook will:
- Change the root password
- Create an admin user with sudo rights
- Add your public keys for SSH access
- Disable password authentication
- Disable root login over SSH

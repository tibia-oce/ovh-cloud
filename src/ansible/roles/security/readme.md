# Security Role

This role provides security hardening for debian servers, focusing on SSH configuration, fail2ban setup, and unattended updates. It attempts to:
  - Install software to monitor bad SSH access (fail2ban)
  - Configure SSH to be more secure (disabling root login, requiring key-based authentication, and allowing a custom SSH port to be set)
  - Securely configure user accounts and SSH keys (this role assumes you won't be using password authentication or logging in as root in future)
  - Set up automatic updates (if configured to do so)

## Requirements

- **Operating System:** Debian (the role will assert if applied on non-Debian systems)

## Role Variables

All configurable options are listed in `defaults/main.yml`. Key variables include:

- **SSH Settings:**
  - `security_ssh_port`
  - `security_ssh_password_authentication`
  - `security_ssh_permit_root_login`
  - `security_ssh_config_path`
- **Fail2Ban:**
  - `security_fail2ban_enabled`
  - `security_fail2ban_custom_configuration_template`
- **Autoupdate:**
  - `security_autoupdate_enabled`
  - `security_autoupdate_reboot`
  - `security_autoupdate_reboot_time`

Custom values can be overridden via inventory files or group/host variable files.  Just ensure you know what you are doing so you don't lock yourself out.

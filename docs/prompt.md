
# OVH Cloud Server Setup

This repository contains Ansible playbooks for setting up and managing OVH cloud servers from initial provision to a 'operational-ready' state for hosting Tibia servers (like theforgottenserver and canary server) and related services.  It will walk through every step following just purchasing a OVH VPS and recieving the credentials.

## Overview

The repository runs on a `justfile` with commands for common operations - including walking the user through setting up their environment (with docker engine/desktop, ssh keys, environment for ansible). The justfile must be OS-agnostic, it needs to be run for both CMD on windows and unix terminals.

These playbooks automate the process of setting up a secure, well-configured Linux environment on a fresh OVH server. The goal is to provide a consistent, repeatable, and secure foundation for hosting Tibia server stacks with databases, proxies, and web interfaces.

## Directory structure
```
ovh-cloud
├─ 📁docs
│  ├─ 📄credentials.md
│  ├─ 📄just.md
│  └─ 📄prompt.md
├─ 📁src
│  ├─ 📁ansible
│  │  ├─ 📁inventory
│  │  │  ├─ 📁group_vars
│  │  │  │  └─ 📄all.yml
│  │  │  ├─ 📄.gitignore
│  │  │  ├─ 📄hosts.example.yml
│  │  │  ├─ 📄hosts.yml
│  │  │  └─ 📄readme.md
│  │  ├─ 📁keys
│  │  │  ├─ 📄.gitignore
│  │  │  ├─ 📄readme.md
│  │  │  ├─ 📄vps-macos.pub
│  │  │  └─ 📄vps-windows.pub
│  │  ├─ 📁playbooks
│  │  │  └─ 📄bootstrap.yml
│  │  ├─ 📄ansible.cfg
│  │  └─ 📄requirements.yml
│  ├─ 📁docker
│  │  └─ 📄docker-compose.yaml
│  └─ 📁scripts
│     ├─ 📄add-known-host.sh
│     ├─ 📄colours.just
│     ├─ 📄first-login.sh
│     ├─ 📄generate-keys.sh
│     ├─ 📄inventory.sh
│     └─ 📄select-or-generate-key.sh
├─ 📄.gitignore
├─ 📄justfile
└─ 📄readme.md
```

## Playbooks

| Playbook | Description | Purpose |
|----------|-------------|---------|
| `bootstrap.yml` | Initial server setup | Secures SSH, creates users, sets up firewall and fail2ban |
| `backup.yml` | Backup configuration | Sets up database backups and retention policies |
| `monitoring.yml` | Monitoring stack | Deploys Prometheus, Grafana, and system metrics collection |
| `network.yml` | Network and SSL | Configures Traefik, Let's Encrypt, and Cloudflare integration |
| `docker.yml` | Docker environment | Installs Docker Engine, Compose, and configures permissions |
| `tibia.yml` | Tibia server stack | Deploys the complete Tibia server environment |

# src\ansible\ansible.cfg
[defaults]
inventory = /ansible/inventory/hosts.yml
host_key_checking = False
retry_files_enabled = False
remote_tmp = /tmp/.ansible/tmp
roles_path = roles

------------


Help me design a production-ish grade ansible directory.  I don't want to use ansible secrets, and ansible will be run from a container to trigger/run the playbooks.



# OVH Cloud Server Setup

This repository contains Ansible playbooks for setting up and managing OVH cloud servers from initial provision to a 'operational-ready' state for hosting Tibia servers and related services.

Ansible is idempotent. This means you can run it over and over again to keep your servers configured.  Let's say, in a week, you disable ufw. If you run this script again, it will turn ufw back on. The ansible concept is that it maintains a **solid state of your server**, even if you run it multiple times. 

## Requirements

- Git
- Bash terminal (git bash works fine for windows)
- Docker (for cross-platform usage of ansible)
- Just command runner (`brew install just`, `winget install --id Casey.Just --exact` etc.)

## Overview

These playbooks automate the process of setting up a secure, well-configured Linux environment on a fresh VPS. The goal is to provide a consistent, repeatable, and secure foundation for hosting Tibia server stacks with databases, proxies, and web interfaces.

## Playbooks

| Playbook | Description | Purpose |
|----------|-------------|---------|
| `bootstrap.yml` | Initial server setup | Secures SSH, creates users, sets up firewall and fail2ban |
| `backup.yml` | Backup configuration | Sets up database backups and retention policies |
| `monitoring.yml` | Monitoring stack | Deploys Prometheus, Grafana, and system metrics collection |
| `network.yml` | Network and SSL | Configures Traefik, Let's Encrypt, and Cloudflare integration |
| `docker.yml` | Docker environment | Installs Docker Engine, Compose, and configures permissions |
| `tibia.yml` | Tibia server stack | Deploys the complete Tibia server environment |

## Quick Start

1. Clone this repository
   ```
   git clone https://github.com/tibia-oce/ovh-cloud.git
   cd ovh-cloud
   ```

2. Run the bootstrap playbook:
   ```
   just setup
   ```

2. Run the bootstrap playbook:
   ```
   just bootstrap
   ```

## Usage

The repository includes a `justfile` with commands for common operations:

- `just run-playbook [playbook]` - Run a specific playbook
- `just setup` - Test connectivity to all servers
- `just ping` - Test connectivity to all servers
- `just bootstrap` - Run the initial server setup
- `just setup-tibia` - Set up the complete Tibia server stack

## Configuration

After running the `just setup` script, you can edit the following files to customise your deployment:

- `group_vars/all.yml` - Global variables
- `group_vars/tibia_servers.yml` - Tibia-specific configuration
- `inventory/hosts.yml` - Server inventory

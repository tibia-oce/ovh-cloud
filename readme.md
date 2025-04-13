# OVH Cloud Server Setup

This repository contains Ansible playbooks for setting up and managing OVH cloud servers from initial provision to a 'operational-ready' state for hosting Tibia servers and related services.

## Requirements

- Git
- Bash terminal (git bash works fine for windows)
- Docker (for cross-platform usage of ansible)
- Just command runner (`brew install just`, `choco install just`, etc.)

## Overview

These playbooks automate the process of setting up a secure, well-configured Linux environment on a fresh OVH server. The goal is to provide a consistent, repeatable, and secure foundation for hosting Tibia server stacks with databases, proxies, and web interfaces.

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
   git clone https://github.com/yourusername/ovh.git
   cd ovh
   ```

2. Add your SSH public keys to the `src/ansible/keys` directory

3. Configure your inventory in `inventory/hosts.yml`

4. Run the bootstrap playbook:
   ```
   just run-playbook bootstrap.yml
   ```

## Usage

The repository includes a `justfile` with commands for common operations:

- `just run-playbook [playbook]` - Run a specific playbook
- `just setup` - Test connectivity to all servers
- `just ping` - Test connectivity to all servers
- `just bootstrap` - Run the initial server setup
- `just setup-tibia` - Set up the complete Tibia server stack

## Playbook Execution Order

For a fresh server, run the playbooks in this order:

1. `bootstrap.yml` - Basic server setup and security
2. `docker.yml` - Set up Docker environment
3. `network.yml` - Configure networking and SSL
4. `monitoring.yml` - Set up monitoring
5. `backup.yml` - Configure backups
6. `tibia.yml` - Deploy the Tibia server stack

## Configuration

Edit the following files to customize your deployment:

- `group_vars/all.yml` - Global variables
- `group_vars/tibia_servers.yml` - Tibia-specific configuration
- `inventory/hosts.yml` - Server inventory

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

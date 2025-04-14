import 'src/scripts/colours.just'

# ------------------------------------------------------
# Default Command
# ------------------------------------------------------
default:
    @just help


# ------------------------------------------------------
# Help Command
# ------------------------------------------------------
help:
    @just _echo-white "OVH Cloud Ansible CLI"
    @echo
    @just _echo-white "Usage:"
    @echo "  just [COMMAND]"
    @echo
    @just _echo-yellow "Environment Setup Commands:"
    @echo
    @just _echo-magenta "  setup"
    @just _echo-white "        Checks Docker, config, SSH keys directory (generates new key if empty),"
    @just _echo-white "        and prompts for inventory details."
    @echo
    @just _echo-magenta "  generate-keys"
    @just _echo-white "        Generates a new SSH key pair (private in ~/.ssh, public in src/ansible/keys)."
    @echo
    @just _echo-magenta "  prompt-inventory"
    @just _echo-white "        Prompts the user for inventory details (hosts.yml)."
    @echo
    @just _echo-magenta "  docker-up"
    @just _echo-white "        Starts the Ansible Docker container in the background."
    @echo
    @just _echo-magenta "  docker-down"
    @just _echo-white "        Stops and removes the Ansible Docker container."
    @echo
    @just _echo-magenta "  docker-exec"
    @just _echo-white "        Attaches to the running Ansible container's shell."
    @echo
    @just _echo-yellow "Playbook Commands:"
    @echo
    @just _echo-magenta "  run-playbook <file>"
    @just _echo-white "        Runs an arbitrary Ansible playbook via Docker Compose."
    @echo
    @just _echo-magenta "  bootstrap"
    @just _echo-white "        Applies the bootstrap.yml playbook (initial server hardening)."
    @echo
    @just _echo-magenta "  ping"
    @just _echo-white "        Runs 'ansible all -m ping' to test connectivity to all inventory hosts."
    @echo
    @just _echo-magenta "  docker"
    @just _echo-white "        Applies the docker.yml playbook (installs Docker on remote)."
    @echo
    @just _echo-magenta "  backup"
    @just _echo-white "        Applies the backup.yml playbook (DB backups, schedules)."
    @echo
    @just _echo-magenta "  monitoring"
    @just _echo-white "        Applies the monitoring.yml playbook (Prometheus, Grafana)."
    @echo
    @just _echo-magenta "  network"
    @just _echo-white "        Applies the network.yml playbook (Traefik, SSL, Cloudflare)."
    @echo
    @just _echo-magenta "  tibia"
    @just _echo-white "        Applies the tibia.yml playbook (Tibia server stack)."
    @echo


# ------------------------------------------------------
# Setup
# ------------------------------------------------------
setup:
    @just check-docker
    @echo
    @just check-empty-inventory
    @echo
    @just check-empty-keys
    @echo
    @just setup-common
    @echo
    @bash src/scripts/add-known-host.sh
    @echo
    @just first-login
    @echo
    @just _echo-info "Setup completed successfully..."
    @just _echo-success "Try running 'just ping' to test access to the server."
    @just _echo-success "Then run 'just help' for a list of available playbooks."

first-login:
    @bash src/scripts/first-login.sh
    @just _echo-warning "If you are changing your password for the first time, update the 'ansible_user_password' variable in the src/ansible/inventory/hosts.yml file."

# ------------------------------------------------------
# Check Docker
# ------------------------------------------------------
check-docker:
    @if command -v docker >/dev/null 2>&1; then \
      just _echo-info "🐋 Docker is already installed; skipping installation."; \
    else \
      just _echo-error "❌ Docker is not installed. Please install Docker Desktop:"; \
      just _echo-error "   https://www.docker.com/products/docker-desktop/"; \
      exit 1; \
    fi

# ------------------------------------------------------
# Check Configs
# ------------------------------------------------------
check-configs:
    @mkdir -p src/ansible/inventory
    @mkdir -p src/ansible/keys

    @if [ ! -f ".env" ] && [ -f ".env.example" ]; then \
      cp ".env.example" ".env" && \
      just _echo-success "Created .env from example. Please edit it with your settings."; \
    elif [ ! -f ".env" ]; then \
      touch ".env" && \
      just _echo-warning "Created an empty .env. Please fill it in."; \
    fi

    @if [ ! -f "src/ansible/inventory/hosts.yml" ] && [ -f "src/ansible/inventory/hosts.example.yml" ]; then \
      cp "src/ansible/inventory/hosts.example.yml" "src/ansible/inventory/hosts.yml" && \
      just _echo-success "Created hosts.yml from example."; \
    elif [ ! -f "src/ansible/inventory/hosts.yml" ]; then \
      just _create-basic-inventory && \
      just _echo-warning "Created a basic hosts.yml. (Will be overwritten if you run prompt-inventory)"; \
    fi

    @if [ ! -f "src/ansible/ansible.cfg" ]; then \
      just _create-ansible-cfg && \
      just _echo-success "Created ansible.cfg with standard settings."; \
    fi

_create-basic-inventory:
    @echo "---" > src/ansible/inventory/hosts.yml
    @echo "all:" >> src/ansible/inventory/hosts.yml
    @echo "  hosts:" >> src/ansible/inventory/hosts.yml
    @echo "    your_server:" >> src/ansible/inventory/hosts.yml
    @echo "      ansible_host: your_server_ip" >> src/ansible/inventory/hosts.yml
    @echo "      ansible_user: root" >> src/ansible/inventory/hosts.yml

_create-ansible-cfg:
    @echo "[defaults]" > src/ansible/ansible.cfg
    @echo "inventory = src/ansible/inventory/hosts.yml" >> src/ansible/ansible.cfg
    @echo "host_key_checking = False" >> src/ansible/ansible.cfg
    @echo "retry_files_enabled = False" >> src/ansible/ansible.cfg
    @echo "roles_path = src/ansible/roles" >> src/ansible/ansible.cfg


# ------------------------------------------------------
# Prompt Inventory
# ------------------------------------------------------
prompt-inventory:
    @just _echo-cyan "📄 Prompting for inventory (hosts.yml)..."
    @bash src/scripts/inventory.sh

check-empty-inventory:
    @if [ ! -f src/ansible/inventory/hosts.yml ]; then \
      just _echo-warning "No inventory file found at src/ansible/inventory/hosts.yml. Creating a new one..."; \
      just prompt-inventory; \
    else \
      just _echo-info "📄 Inventory file already exists; skipping creation."; \
    fi

# ------------------------------------------------------
# Check if Keys Directory is Empty
# ------------------------------------------------------
check-empty-keys:
    @if find src/ansible/keys -maxdepth 1 -type f -name '*.pub' -print -quit | grep -q .; then \
      just _echo-info "🔑 SSH public key(s) already exist in src/ansible/keys."; \
    else \
      just _echo-warning "No SSH public keys (*.pub) found in src/ansible/keys."; \
      bash src/scripts/select-or-generate-key.sh; \
    fi

# ------------------------------------------------------
# Setup Common
# ------------------------------------------------------
setup-common:
    @just _echo-cyan "📦 Pulling latest ansible image..."
    @docker pull cytopia/ansible:2.13


# ------------------------------------------------------
# Docker Compose Helpers
# ------------------------------------------------------
docker-up:
    @just _echo-cyan "🐳 Starting the Ansible container in background..."
    @docker-compose -f src/docker/docker-compose.yaml up -d ansible
    @just _echo-success "Ansible container is running."

docker-down:
    @just _echo-cyan "🛑 Stopping and removing containers..."
    @docker-compose -f src/docker/docker-compose.yaml down
    @just _echo-success "Containers stopped."

docker-exec:
    @just _echo-cyan "💻 Attaching to the Ansible container..."
    @docker-compose -f src/docker/docker-compose.yaml exec ansible bash


# ------------------------------------------------------
# Ansible: Running Playbooks
# ------------------------------------------------------
run-playbook playbook:
    @just _echo-cyan "🛠 Running playbook {{playbook}}..."
    @docker-compose -f src/docker/docker-compose.yaml run --rm ansible \
      ansible-playbook "{{playbook}}"

bootstrap:
    @just run-playbook playbooks/bootstrap.yml

ping:
    @docker-compose -f src/docker/docker-compose.yaml run --rm ansible \
      ansible all -m ping

networking:
    @just run-playbook playbooks/networking.yml

backup:
    @just run-playbook playbooks/backup.yml

monitoring:
    @just run-playbook playbooks/monitoring.yml

network:
    @just run-playbook playbooks/network.yml

tibia:
    @just run-playbook playbooks/tibia.yml

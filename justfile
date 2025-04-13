import 'src/just/colours.just'

default:
    @just --list

setup:
    @just _echo-cyan "Setting up environment for OVH Ansible playbooks"
    @just check-docker
    @just check-ssh-keys
    @just check-configs
    @just setup-common
    @just _echo-success "Setup completed successfully!"

check-docker:
    @just _echo-cyan "Checking for Docker..."
    @which docker > /dev/null 2>&1 || (just _echo-error "Docker is not installed. Please install Docker first" && just _echo-info "Visit https://docs.docker.com/get-docker/" && exit 1)
    @just _echo-success "Docker is installed"

check-ssh-keys:
    @just _echo-cyan "Checking for SSH keys..."
    @if [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then just _echo-success "SSH keys found"; else just _echo-warning "No SSH keys found"; just _echo-info "Run ssh-keygen -t ed25519 to generate an SSH key pair"; fi
    
    @just _echo-cyan "Setting up keys directory..."
    @mkdir -p keys
    
    @if [ -f "$HOME/.ssh/id_rsa.pub" ] && [ ! -f "keys/id_rsa.pub" ]; then cp "$HOME/.ssh/id_rsa.pub" keys/ && just _echo-success "Copied RSA public key to keys/"; fi
    
    @if [ -f "$HOME/.ssh/id_ed25519.pub" ] && [ ! -f "keys/id_ed25519.pub" ]; then cp "$HOME/.ssh/id_ed25519.pub" keys/ && just _echo-success "Copied ED25519 public key to keys/"; fi
    
    @if [ ! -f "keys/id_rsa.pub" ] && [ ! -f "keys/id_ed25519.pub" ]; then just _echo-warning "No public keys found in keys/ directory"; just _echo-info "Add public keys to keys/ directory before deploying"; fi

check-configs:
    @just _echo-cyan "Checking configuration files..."
    @mkdir -p inventory

    @if [ ! -f ".env" ] && [ -f ".env.example" ]; then cp ".env.example" ".env" && just _echo-success "Created .env file from example. Please edit it with your settings"; elif [ ! -f ".env" ]; then touch ".env" && just _echo-warning "Created empty .env file. You'll need to add your settings"; fi
    
    @if [ ! -f "inventory/hosts.yml" ] && [ -f "inventory/hosts.example.yml" ]; then cp "inventory/hosts.example.yml" "inventory/hosts.yml" && just _echo-success "Created inventory/hosts.yml from example. Please edit it with your server details"; elif [ ! -f "inventory/hosts.yml" ]; then just _create-basic-inventory && just _echo-warning "Created basic inventory/hosts.yml. Please edit it with your server details"; fi
    
    @if [ ! -f "ansible.cfg" ]; then just _create-ansible-cfg && just _echo-success "Created ansible.cfg file with standard settings"; fi

_create-basic-inventory:
    @echo "# OVH Server Inventory" > inventory/hosts.yml
    @echo "all:" >> inventory/hosts.yml
    @echo "  hosts:" >> inventory/hosts.yml
    @echo "    your_server:" >> inventory/hosts.yml
    @echo "      ansible_host: your_server_ip" >> inventory/hosts.yml
    @echo "      ansible_user: root" >> inventory/hosts.yml

_create-ansible-cfg:
    @echo "[defaults]" > ansible.cfg
    @echo "inventory = inventory/hosts.yml" >> ansible.cfg
    @echo "host_key_checking = False" >> ansible.cfg
    @echo "retry_files_enabled = False" >> ansible.cfg
    @echo "roles_path = roles" >> ansible.cfg

setup-common:
    @just _echo-cyan "Running common setup tasks..."
    @just _echo-cyan "Pulling the Ansible Docker image..."
    @docker pull cytopia/ansible
    
    @just _echo-info "Next steps:"
    @just _echo-info "1. Edit .env with your settings"
    @just _echo-info "2. Edit inventory/hosts.yml with your server details" 
    @just _echo-info "3. Run 'just bootstrap' to set up your first server"

run-playbook playbook:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Running playbook {{playbook}}"

bootstrap:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Bootstrapping server"

ping:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Pinging all hosts"

docker:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Setting up Docker engine"

backup:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Setting up backups"

monitoring:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Setting up monitoring"

network:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Setting up networking"

tibia:
    @just _echo-yellow "[NOT YET IMPLEMENTED] Deploying Tibia server stack"

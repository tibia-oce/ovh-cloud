setup:
    #!/usr/bin/env sh
    if [ "$(uname -s)" = "Linux" ] || [ "$(uname -s)" = "Darwin" ]; then
        just setup-unix
    elif [ "$OS" = "Windows_NT" ] || [ "$(uname -s)" = "MINGW"* ] || [ "$(uname -s)" = "MSYS"* ]; then
        just setup-windows
    else
        echo "❌ Unknown operating system. Please run setup manually."
        exit 1
    fi
    just setup-common

setup-unix:
    @echo "🔧 Setting up environment for OVH Ansible playbooks on Unix-like system..."
    
    # Check for Docker
    @echo "Checking for Docker..."
    @if ! command -v docker &> /dev/null; then 
        echo "❌ Docker is not installed. Please install Docker first."; 
        echo "   Visit https://docs.docker.com/get-docker/"; 
        exit 1; 
    else 
        echo "✅ Docker is installed."; 
    fi
    
    # Check for SSH keys
    @echo "Checking for SSH keys..."
    @if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then 
        echo "❌ No SSH keys found. Generating a new SSH key pair..."; 
        ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""; 
        echo "✅ SSH key pair generated at ~/.ssh/id_ed25519"; 
    else 
        echo "✅ SSH keys found."; 
    fi
    
    # Create ssh_keys directory if it doesn't exist
    @echo "Setting up ssh_keys directory..."
    @mkdir -p ssh_keys
    
    # Copy public keys to ssh_keys directory if they don't exist there
    @if [ -f ~/.ssh/id_rsa.pub ] && [ ! -f ssh_keys/id_rsa.pub ]; then 
        cp ~/.ssh/id_rsa.pub ssh_keys/; 
        echo "✅ Copied RSA public key to ssh_keys/"; 
    fi
    
    @if [ -f ~/.ssh/id_ed25519.pub ] && [ ! -f ssh_keys/id_ed25519.pub ]; then 
        cp ~/.ssh/id_ed25519.pub ssh_keys/; 
        echo "✅ Copied ED25519 public key to ssh_keys/"; 
    fi
    
    # Check for example config files and copy them if needed
    @echo "Checking configuration files..."
    @if [ ! -f .env ] && [ -f .env.example ]; then 
        cp .env.example .env; 
        echo "✅ Created .env file from example. Please edit it with your settings."; 
    fi
    
    @if [ ! -f inventory/hosts.yml ] && [ -f inventory/hosts.example.yml ]; then 
        cp inventory/hosts.example.yml inventory/hosts.yml; 
        echo "✅ Created inventory/hosts.yml from example. Please edit it with your server details."; 
    fi

# Setup for Windows systems
setup-windows:
    @echo "🔧 Setting up environment for OVH Ansible playbooks on Windows..."
    @powershell -Command "& {                                                            \
        # Check for Docker                                                             \
        Write-Host 'Checking for Docker...';                                           \
        if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {                 \
            Write-Host '❌ Docker is not installed. Please install Docker first.';      \
            Write-Host '   Visit https://docs.docker.com/get-docker/';                 \
            exit 1;                                                                    \
        } else {                                                                       \
            Write-Host '✅ Docker is installed.';                                       \
        }                                                                              \
                                                                                        \
        # Check for SSH keys                                                           \
        Write-Host 'Checking for SSH keys...';                                         \
        if (-not (Test-Path -Path \"$env:USERPROFILE\\.ssh\\id_rsa\") -and -not (Test-Path -Path \"$env:USERPROFILE\\.ssh\\id_ed25519\")) { \
            Write-Host '❌ No SSH keys found. Generating a new SSH key pair...';       \
            if (-not (Test-Path -Path \"$env:USERPROFILE\\.ssh\")) {                  \
                New-Item -ItemType Directory -Path \"$env:USERPROFILE\\.ssh\" | Out-Null; \
            }                                                                          \
            ssh-keygen -t ed25519 -f \"$env:USERPROFILE\\.ssh\\id_ed25519\" -N '\"\"'; \
            Write-Host '✅ SSH key pair generated at %USERPROFILE%\\.ssh\\id_ed25519'; \
        } else {                                                                       \
            Write-Host '✅ SSH keys found.';                                           \
        }                                                                              \
                                                                                        \
        # Create ssh_keys directory if it doesn't exist                                \
        Write-Host 'Setting up ssh_keys directory...';                                 \
        if (-not (Test-Path -Path 'ssh_keys')) {                                       \
            New-Item -ItemType Directory -Path 'ssh_keys' | Out-Null;                  \
        }                                                                              \
                                                                                        \
        # Copy public keys to ssh_keys directory if they don't exist there             \
        if ((Test-Path -Path \"$env:USERPROFILE\\.ssh\\id_rsa.pub\") -and -not (Test-Path -Path 'ssh_keys\\id_rsa.pub')) { \
            Copy-Item -Path \"$env:USERPROFILE\\.ssh\\id_rsa.pub\" -Destination 'ssh_keys\\'; \
            Write-Host '✅ Copied RSA public key to ssh_keys\\';                      \
        }                                                                              \
                                                                                        \
        if ((Test-Path -Path \"$env:USERPROFILE\\.ssh\\id_ed25519.pub\") -and -not (Test-Path -Path 'ssh_keys\\id_ed25519.pub')) { \
            Copy-Item -Path \"$env:USERPROFILE\\.ssh\\id_ed25519.pub\" -Destination 'ssh_keys\\'; \
            Write-Host '✅ Copied ED25519 public key to ssh_keys\\';                  \
        }                                                                              \
                                                                                        \
        # Check for example config files and copy them if needed                       \
        Write-Host 'Checking configuration files...';                                  \
        if (-not (Test-Path -Path '.env') -and (Test-Path -Path '.env.example')) {     \
            Copy-Item -Path '.env.example' -Destination '.env';                        \
            Write-Host '✅ Created .env file from example. Please edit it with your settings.'; \
        }                                                                              \
                                                                                        \
        if (-not (Test-Path -Path 'inventory\\hosts.yml') -and (Test-Path -Path 'inventory\\hosts.example.yml')) { \
            Copy-Item -Path 'inventory\\hosts.example.yml' -Destination 'inventory\\hosts.yml'; \
            Write-Host '✅ Created inventory\\hosts.yml from example. Please edit it with your server details.'; \
        }                                                                              \
    }"

# Common setup tasks that work on both platforms
setup-common:
    @echo "Running common setup tasks..."
    # Pull the Docker image for Ansible
    @echo "Pulling the Ansible Docker image..."
    @docker pull cytopia/ansible
    
    @echo "🎉 Setup complete! You're ready to run Ansible playbooks with Just."
    @echo "Next steps:"
    @echo "1. Edit .env with your settings"
    @echo "2. Edit inventory/hosts.yml with your server details"
    @echo "3. Run 'just bootstrap' to set up your first server"

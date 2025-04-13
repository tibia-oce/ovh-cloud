import 'just/utils.just'

default:
    @just --list

setup:
    @just _echo-yellow "[TO BE IMPLEMENTED] Setting up environment for OVH Ansible playbooks"

check-docker:
    @just _echo-yellow "[TO BE IMPLEMENTED] Checking for Docker"

check-ssh-keys:
    @just _echo-yellow "[TO BE IMPLEMENTED] Checking and setting up SSH keys"

check-configs:
    @just _echo-yellow "[TO BE IMPLEMENTED] Checking configuration files"

setup-common:
    @just _echo-yellow "[TO BE IMPLEMENTED] Running common setup tasks"

run-playbook playbook:
    @just _echo-yellow "[TO BE IMPLEMENTED] Running playbook {{playbook}}"

bootstrap:
    @just _echo-yellow "[TO BE IMPLEMENTED] Bootstrapping server"

ping:
    @just _echo-yellow "[TO BE IMPLEMENTED] Pinging all hosts"

docker:
    @just _echo-yellow "[TO BE IMPLEMENTED] Setting up Docker engine"

backup:
    @just _echo-yellow "[TO BE IMPLEMENTED] Setting up backups"

monitoring:
    @just _echo-yellow "[TO BE IMPLEMENTED] Setting up monitoring"

network:
    @just _echo-yellow "[TO BE IMPLEMENTED] Setting up networking"

tibia:
    @just _echo-yellow "[TO BE IMPLEMENTED] Deploying Tibia server stack"

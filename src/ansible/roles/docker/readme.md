# Docker Role

This role provides the installation and configuration of Docker on Debian-based systems. It installs all necessary Docker packages (Docker CE, CLI, containerd, and related plugins), adds the official Docker apt repository with the proper GPG key, and ensures that Docker is started and enabled at boot. The role also manages Docker-related user group memberships so that specified users (e.g. a deploy user) have proper permissions.

## Requirements

- **Operating System:** Debian or Ubuntu  
  *This role asserts that it only runs on Debian-based systems and will fail if applied on any non-Debian system.*

## Role Variables

The role uses a variety of variables to customise its behavior. Key variables include:

- **docker_edition**  
  The edition of Docker to install (e.g., `ce` for Community Edition).

- **docker_packages**  
  A list of Docker packages to install (e.g., `docker-ce`, `docker-ce-cli`, `containerd.io`, etc.).

- **docker_packages_state**  
  The desired state for the Docker packages (e.g., `present`).

- **docker_obsolete_packages**  
  A list of old or conflicting Docker packages that should be removed.

- **docker_add_repo**  
  Boolean flag indicating whether to add the Docker apt repository.

- **docker_apt_gpg_key**  
  URL for the Docker GPG key.

- **docker_apt_gpg_key_checksum**  
  Checksum for verifying the Docker GPG key.

- **docker_apt_repository**  
  The Docker apt repository string, which includes the architecture and the keyring reference.

- **docker_apt_ansible_distribution**  
  A workaround variable to ensure the correct distribution is used for the Docker repository (useful for Ubuntu variants).

- **docker_apt_arch**  
  The architecture for Docker packages (e.g., `amd64`).

- **docker_apt_release_channel**  
  The release channel for the repository (e.g., `stable`).

- **docker_apt_filename**  
  The filename used for the Docker apt repository in `/etc/apt/sources.list.d`.

- **docker_daemon_options**  
  A dictionary of custom options for the Docker daemon, which will be written to `/etc/docker/daemon.json`.

- **docker_service_state** and **docker_service_enabled**  
  Define the desired state and whether the Docker service should be enabled at boot.

- **docker_users**  
  A list of users who should be added to the Docker group (allowing them to run Docker commands).

- **docker_install_compose_plugin** and **docker_compose_package**  
  Control the installation of the Docker Compose plugin.

- **docker_install_compose**, **docker_compose_version**, **docker_compose_arch**, **docker_compose_url**, and **docker_compose_path**  
  Variables for managing the standalone Docker Compose binary if desired.

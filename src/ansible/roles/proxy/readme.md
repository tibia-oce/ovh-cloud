# Proxy Role

This role provides the installation and configuration of Traefik as a reverse proxy to securely route HTTP/HTTPS and TCP traffic on your Debian VPS. It is designed to manage routing for your gaming stack, LAMP stack, or containerised services while also handling automated certificate management via Let's Encrypt. The role leverages Traefik's dynamic configuration and middleware features to enforce security policies, such as rate limiting and authentication for the Traefik dashboard.

## Requirements

- **Operating System:** Debian or Ubuntu  
  *This role asserts that it only runs on Debian-based systems and will fail if applied on any non-Debian system.*

## Role Variables

The role uses a variety of variables to customise its behavior. Key variables include:

- **traefik_dashboard:**  
  Options to enable and secure the Traefik dashboard, including any authentication middleware settings.

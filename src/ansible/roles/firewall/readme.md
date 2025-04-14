# Firewall Role

This role provides firewall configuration and management for OVH cloud servers running Debian-based systems. It attempts to:
  - Install and ensure iptables is present.
  - Flush existing iptables rules on the first run.
  - Deploy a custom firewall script using templates.
  - Configure firewall rules based on defined variables (allowed ports, forwarded ports, additional custom rules, etc.).
  - Optionally disable conflicting firewall services (e.g., ufw) if configured.

## Requirements

- **Operating System:** Debian (the role will assert if applied on non-Debian systems)

## Role Variables

All configurable options are defined in `defaults/main.yml`. Key variables include:

- **`firewall_state`**  
  The state to which the firewall service should be set (e.g., `started`).

- **`firewall_enabled_at_boot`**  
  Boolean to specify if the firewall should be enabled on system boot.

- **`firewall_flush_rules_and_chains`**  
  Whether to flush and reset all existing iptables rules and chains on the first run.

- **`firewall_template`**  
  The template file used to generate the firewall script (default: `firewall.bash.j2`).

- **`firewall_allowed_tcp_ports`**  
  List of TCP ports to allow (e.g., SSH, HTTP, HTTPS).

- **`firewall_allowed_udp_ports`**  
  List of UDP ports to allow.

- **`firewall_forwarded_tcp_ports`**  
  List of objects defining TCP port forwarding rules.

- **`firewall_forwarded_udp_ports`**  
  List of objects defining UDP port forwarding rules.

- **`firewall_additional_rules`**  
  Additional custom iptables rules as needed.

- **`firewall_enable_ipv6`**  
  Boolean to enable IPv6 configuration via ip6tables.

- **`firewall_ip6_additional_rules`**  
  Additional custom rules for IPv6 firewall configuration.

- **`firewall_log_dropped_packets`**  
  Whether to log dropped packets (if true, logs are generated at a limited rate).

- **`firewall_disable_ufw`**  
  Set to true to disable ufw (the Ubuntu firewall) if it is installed.

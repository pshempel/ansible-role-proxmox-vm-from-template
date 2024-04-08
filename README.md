
# Ansible Role: Proxmox VM Deployer

This Ansible role facilitates the automated deployment and configuration of virtual machines (VMs) on a Proxmox Virtual Environment (PVE) cluster. It is designed to streamline and standardize the process of VM creation, allowing for both detailed customization and quick setup with sensible defaults.

## Features:

- **Dynamic VM Placement**: Automatically selects the Proxmox node with the most available resources (memory and CPU) for new VMs.
- **Template-Based Deployment**: Allows for VM creation based on specified templates, facilitating standardization and rapid deployment.
- **Flexible Networking**: Supports custom network configurations, including the choice of bridge interfaces and VLAN tagging.
- **Customizable VM Parameters**: Configure VM settings such as memory size, number of CPU cores, and disk size, with the ability to set defaults or specify per VM.
- **Optional VMID Specification**: Automatically uses the next available VMID or allows for manual specification.
- **Cloud-Init Integration**: Supports cloud-init for additional VM configuration upon boot, such as setting user credentials and running custom scripts.

## Requirements:

- Ansible 2.9 or higher.
- Access to a Proxmox VE cluster with necessary privileges.
- Proxmox API tokens for authentication with appropriate permissions.

## Role Variables:

Variables can be defined in the `defaults/main.yml` for global defaults or overridden for specific VMs in the playbook:

```yaml
default_memory_size: 2048                                      # Default VM memory size in MB
default_disk_size: "30G"                                       # Default VM disk size use +30G to add or 30G to set absolute size
default_cpu_cores: 2                                           # Default number of CPU cores per VM If ommited will be from tempalte
default_cpu_sockets: 1                                         # Number of CPU sockets If ommited will be from tempalte.
default_boot_on_start: yes                                     # Boot VM on start of Proxmox
default_template_tag: "bookworm"                               # Default VM template tag to find for template clone
default_pool: "vm_pools"                                       # Default pool for VMs. Set to an empty string or omit for no default pool.
default_domain_name: "example.com"                             # Default domain name for VMs, this is appended to vm name
default_bridge: "vmbr0"                                        # Default network bridge
default_disk: "scsi0"                                          # Default disk from template
default_validate_certs: "yes"                                  # Default verify proxmox ssl cert yes or no default is false
preferred_storage_type: 'zfs'                                  # Preferred storage type, e.g., 'zfs', 'lvm', 'iscsi'
vm_network_vlan: 10                                            # Default VLAN tag empty if not provided
proxmox_api_url: "https://proxmox1.example.com:8006/api2/json" # Proxmox API URL
proxmox_api_host: "proxmox1.example.com:8006"                  # do not include https or http
include_custom_cloud_init: no                                  # Whether to include custom cloud init
local_cloud_init_path: "/path/to/local/cloud_init_files/"      # Path on shared storage that is available to proxmox cluster # must have ssh root 
cloud_init_storage_path: "local:snippets/"                     # Proxmox storage name that has snippets defined and is accessable to the cloud-init image
custom_cloud_init_behavior: "append"                           # Options: "append", "replace" Append will use vendor opbject
skip_package_check: yes                                        # whether to skip local package install on run or not
```

More detailed configurations and examples can be found in the `defaults/main.yml` file.

## Usage:

Include the role in your playbook and define the necessary variables:

```yaml
- hosts: localhost
  gather_facts: no
  roles:
    - ansible-role-proxmox-vm-from-template
  vars_files:                                 
    - vars/proxmox_secrets.yml                         # Contains encrypted API credentials
    - vars/defaults.yml                                # Over Ride defaults in role
  vars:
    vms:
      - name: "webserver"
        node: "auto"                                   # Use 'auto' for dynamic node selection
        memory: 4096
        disk_size: "50G"
        template_tag: "Ubuntu2004"                    # Tag to search for on the tamplate
        ipv4: "192.168.1.10"                          # For cloud init
        vm_network_vlan: 100
        tags: "tag-with-comma-delimmited,other-tag"   # Tags cannot have spaces or underscores "_" or periods "."
```

## Examples:

Deploying a single VM using defaults but with specific memory size and a custom template:

```yaml
- hosts: localhost
  roles:
    - ansible-role-proxmox-vm-from-template
  vars:
    vms:
      - name: "dbserver"
        template_tag: "Debian10"
        memory: 8192
```

Deploying multiple VMs with different configurations:

```yaml
- hosts: localhost
  roles:
    - ansible-role-proxmox-vm-from-template
  vars:
    vms:
      - name: "appserver"
        template_tag: "Ubuntu20.04"
        memory: 4096
        cores: 4
        vm_network_vlan: 200
      - name: "testserver"
        template_tag: "CentOS8"
        memory: 2048
        vmid: 150  # Specify VMID directly
```

## License:

 License GPL-2.0-or-later

## Author Information:

This role was created by Chat GPT and Philip S. Hempel.

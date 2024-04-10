
# Ansible Role: Proxmox VM Deployer from VM Template

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
pvmt_default_memory_size: 2048                                 # Default VM memory size in MB
pvmt_default_disk_size: "30G"                                  # Default VM disk size use +30G to add or 30G to set absolute size
pvmt_default_cpu_cores: 2                                      # Default number of CPU cores per VM If ommited will be from tempalte
pvmt_default_cpu_sockets: 1                                    # Number of CPU sockets If ommited will be from tempalte.
pvmt_default_boot_on_start: yes                                # Boot VM on start of Proxmox
pvmt_default_template_tag: "bookworm"                          # Default VM template tag to find for template clone
pvmt_default_proxmox_pool: "vm_pools"                          # Default pool for VMs. Set to an empty string or omit for no default pool.
pvmt_default_domain_name: "example.com"                        # Default domain name for VMs, this is appended to vm name
pvmt_default_proxmox_bridge: "vmbr0"                           # Default network bridge
pvmt_default_vm_disk: "scsi0"                                  # Default disk from template
pvmt_default_validate_certs: "yes"                             # Default verify proxmox ssl cert yes or no default is false
pvmt_default_vm_start_now: "no"                                # Whether to start VM once template is cloned and configured
pvmt_default_vm_agent: "no"                                    # Enable agent on vm
pvmt_preferred_storage_type: 'zfs'                             # Preferred storage type, e.g., 'zfs', 'lvm', 'iscsi'
pvmt_default_vm_network_vlan: 10                               # Default VLAN tag empty if not provided
pvmt_default_proxmox_api_timeout: 360                          # Set how long to wait for Proxmox to timeout during api calls
pvmt_debug_mode_enable: false
include_custom_cloud_init: no                                  # Whether to include custom cloud init
local_cloud_init_path: "/path/to/local/cloud_init_files/"      # Path on shared storage that is available to proxmox cluster # must have ssh root 
cloud_init_storage_path: "local:snippets/"                     # Proxmox storage name that has snippets defined and is accessable to the cloud-init image
custom_cloud_init_behavior: "append"                           # Options: "append", "replace" Append will use vendor object
pvmt_skip_package_check: yes                                        # whether to skip local package install on run or not
proxmox_api_url: "https://proxmox1.example.com:8006/api2/json" # Proxmox API URL
proxmox_api_host: "proxmox1.example.com:8006"                  # do not include https or http
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
      # You must have the following in your secrets file, use ansible-vault to encyrpt 
      # proxmox_api_token_id "username@pve!token_id   # format is  user@realm!tokenid
      # proxmox_api_token_secret                      # token secret provided by proxmox
    - vars/proxmox_secrets.yml                        # Contains encrypted API credentials
      # Fill in the above from defaults/main.yml to overide defaults 
    - vars/defaults.yml                                # Over Ride defaults in role
  vars:
    vms:
      - name: "webserver"
        node: "auto"                                  # Use 'auto' for dynamic node selection
        memory: 4096
        disk_size: "50G"
        template_tag: "Ubuntu2004"                    # Tag to search for on the tamplate
        ipv4: "192.168.1.10"                          # For cloud init
        vm_network_vlan: 100
        vm_start_now: true                            # whether to start vm after creation, overides default
        vm_tags: "tag-with-comma-delimmited,other-tag"   # Tags cannot have spaces or underscores "_" or periods "."
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
        template_tag: "Ubuntu2004"                # what is the tag on the tempate to clone
        memory: 4096
        cores: 4
        vm_network_vlan: 200
      - name: "testserver"
        template_tag: "CentOS8"
        memory: 2048
        proxmox_pool: "developers_pool"
        vm_tags: "debian12,webserver,cloud-init"  # Tag to apply to the vm after cloneing
        vmid: 150                                 # Specify VMID directly if you don't want proxmox to use the next vmid, will be skipped if exists
```

## License:
 License GPL-2.0-or-later

## Author Information:

This role was created by Chat GPT and Philip S. Hempel.

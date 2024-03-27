
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
default_memory_size: 2048  # Default VM memory size in MB
default_disk_size: "30G"   # Default VM disk size
default_cpu_cores: 2       # Default number of CPU cores per VM
default_domain_name: "example.com"  # Default domain name for VMs
default_bridge: "vmbr0"    # Default network bridge
```

More detailed configurations and examples can be found in the `defaults/main.yml` file.

## Usage:

Include the role in your playbook and define the necessary variables:

```yaml
- hosts: localhost
  gather_facts: no
  roles:
    - my_proxmox_vm_role
  vars:
    vms:
      - name: "webserver"
        node: "auto"  # Use 'auto' for dynamic node selection
        memory: 4096
        disk_size: "50G"
        template_tag: "Ubuntu 20.04"
        ipv4: "192.168.1.10"
        vm_network_vlan: 100
```

## Examples:

Deploying a single VM using defaults but with specific memory size and a custom template:

```yaml
- hosts: localhost
  roles:
    - my_proxmox_vm_role
  vars:
    vms:
      - name: "dbserver"
        template_tag: "Debian 10"
        memory: 8192
```

Deploying multiple VMs with different configurations:

```yaml
- hosts: localhost
  roles:
    - my_proxmox_vm_role
  vars:
    vms:
      - name: "appserver"
        template_tag: "Ubuntu 20.04"
        memory: 4096
        cores: 4
        vm_network_vlan: 200
      - name: "testserver"
        template_tag: "CentOS 8"
        memory: 2048
        vmid: 150  # Specify VMID directly
```

## License:

Specify your license or state that the project is unlicensed.

## Author Information:

This role was created by [Your Name].

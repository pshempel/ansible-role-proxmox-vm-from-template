#!/usr/bin/env python3

# fetch_vmid.py
import sys
from proxmoxer import ProxmoxAPI

def fetch_vmid(hostname, username, token_name, token_value, vm_name):
    proxmox = ProxmoxAPI(hostname, user=username, token_name=token_name, token_value=token_value, verify_ssl=False)
    for vm in proxmox.cluster.resources.get(type='vm'):
        if vm['name'] == vm_name:
            print(vm['vmid'])  # Output the VMID for Ansible to capture
            return
    print("Not found", file=sys.stderr)  # Error message in case VM is not found

if __name__ == "__main__":
    hostname = sys.argv[1]
    username = sys.argv[2]
    token_name = sys.argv[3]
    token_value = sys.argv[4]
    vm_name = sys.argv[5]
    fetch_vmid(hostname, username, token_name, token_value, vm_name)

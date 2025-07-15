# Fixes Applied to ansible-role-proxmox-vm-from-template

## Date: 2025-07-15

### 1. Fixed Missing SSL Certificate Validation
**File:** `tasks/prepare.yml:44`
**Issue:** Storage fetch API call was missing `validate_certs` parameter, causing SSL certificate verification failures
**Fix:** Added `validate_certs: "{{ pvmt_default_validate_certs | default('no') }}"`

### 2. Fixed Per-VM Template Selection Bug
**Issue:** Role was using global template selection instead of per-VM template tags. VMs with custom `template_tag` (like "plucky" or "ubuntu-template") were incorrectly using the default template.

**Root Cause:** The `selected_template_vmid` was set globally once and never updated per VM.

**Files Modified:**
- Created new task file: `tasks/select_template_for_vm.yml`
- Modified: `tasks/clone_and_configure_each_vm.yml`
- Modified: `tasks/clone_vm_from_template.yml`
- Modified: `tasks/check_template_location.yml`
- Modified: `tasks/migrate_template_to_target_node.yml`
- Modified: `tasks/refresh_template_node_location.yml`

**Fix Details:**
- Added per-VM template selection that respects each VM's `template_tag`
- Created `vm_selected_template_vmid` and `vm_template_current_node` variables for per-VM use
- Updated all tasks to use `vm_selected_template_vmid | default(selected_template_vmid)` pattern

### 3. Missing Default Variables
**Issue:** Several default variables from `defaults/main.yml` were not being loaded when using tasks directly
**Variables Added to Test Playbooks:**
- `pvmt_default_template_tag`
- `pvmt_preferred_storage_type`
- `pvmt_default_cpu_cores`
- `pvmt_default_cpu_sockets`

## Test Results

### Before Fix:
- Template with tags "plucky;ubuntu-template" (VMID 9002) was not selectable
- All VMs were cloned from the default template (VMID 9000) regardless of their `template_tag`

### After Fix:
- ✅ VMs with `template_tag: "bookworm"` correctly clone from VMID 9000
- ✅ VMs with `template_tag: "plucky"` correctly clone from VMID 9002
- ✅ VMs with `template_tag: "ubuntu-template"` correctly clone from VMID 9002

## Testing Infrastructure

Created comprehensive test examples and documentation:
- `tests/test.yml.example` - Template for creating test playbooks
- `tests/README.md` - Testing guide with security best practices
- Private test files are gitignored to prevent credential leaks

## Recommendations

1. Consider loading role defaults properly when included as tasks
2. Add integration tests for multi-tag template scenarios
3. Document the per-VM template selection feature in README
4. Consider adding validation for template tag existence before cloning
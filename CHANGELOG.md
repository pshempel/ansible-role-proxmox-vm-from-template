# Changelog

## [Unreleased] - 2025-07-15

### Added
- Comprehensive linting setup with yamllint and ansible-lint
- Pre-commit hooks configuration for code quality
- Makefile for easy linting and testing
- Test suite for template selection and VM deployment
- Cleanup playbook for test VMs
- Support for per-VM template selection
- Debug playbooks for troubleshooting

### Fixed
- Fixed template selection bug where VMs with custom template_tag were using default template
- Added missing `validate_certs` parameter in storage fetch task (tasks/prepare.yml:44)
- Fixed requirements.yml indentation syntax error
- Fixed missing default variables when using tasks directly
- Updated meta/main.yml with proper namespace and role name for Galaxy
- Fixed YAML syntax issues (trailing spaces, missing newlines, truthy values)

### Changed
- Improved template selection to support multi-tag templates
- Enhanced error handling and debug output
- Updated .gitignore to exclude test and temporary files
- Standardized boolean values (yes/no → true/false)

### Technical Details
- Created new task file: `tasks/select_template_for_vm.yml` for per-VM template selection
- Added variables `vm_selected_template_vmid` and `vm_template_current_node` for per-VM scope
- Modified 6 task files to support per-VM template selection
- Fixed 100+ linting issues across the codebase
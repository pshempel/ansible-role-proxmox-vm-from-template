# Makefile for ansible-role-proxmox-vm-from-template

.PHONY: help lint lint-yaml lint-ansible fix-yaml test clean install-deps

# Default target
help:
	@echo "Available targets:"
	@echo "  make lint          - Run all linters"
	@echo "  make lint-yaml     - Run yamllint"
	@echo "  make lint-ansible  - Run ansible-lint"
	@echo "  make fix-yaml      - Auto-fix YAML formatting issues"
	@echo "  make test          - Run role tests"
	@echo "  make clean         - Clean temporary files"
	@echo "  make install-deps  - Install required dependencies"

# Run all linters
lint: lint-yaml lint-ansible
	@echo "✓ All linting completed"

# YAML linting
lint-yaml:
	@echo "Running yamllint..."
	@yamllint . > tmp/yamllint_results.log 2>&1 || (cat tmp/yamllint_results.log && exit 1)
	@echo "✓ YAML linting passed"

# Ansible linting
lint-ansible:
	@echo "Running ansible-lint..."
	@ansible-lint > tmp/ansible-lint_results.log 2>&1 || (cat tmp/ansible-lint_results.log && exit 1)
	@echo "✓ Ansible linting passed"

# Fix YAML formatting (requires prettier)
fix-yaml:
	@echo "Auto-fixing YAML files..."
	@find . -name "*.yml" -o -name "*.yaml" | grep -v -E "(tmp/|.cache/|.git/)" | xargs -I {} sh -c 'echo "Fixing: {}" && sed -i "s/[[:space:]]*$$//" {}'
	@echo "✓ YAML fixes applied (trailing spaces removed)"

# Run tests
test:
	@echo "Running tests..."
	@if [ -f tests/test.yml ]; then \
		ansible-playbook tests/test.yml > tmp/test_run.log 2>&1 || (cat tmp/test_run.log && exit 1); \
		echo "✓ Test playbook passed"; \
	else \
		echo "No test.yml found. Copy tests/test.yml.example and configure it."; \
		exit 1; \
	fi

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@rm -rf tmp/*.log
	@rm -rf .cache/
	@find . -name "*.retry" -delete
	@echo "✓ Cleanup completed"

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	@pip3 install --user ansible-lint yamllint
	@ansible-galaxy collection install -r requirements.yml
	@echo "✓ Dependencies installed"

# Run linters with detailed output
lint-verbose:
	@echo "=== YAML Lint Results ==="
	@yamllint . || true
	@echo ""
	@echo "=== Ansible Lint Results ==="
	@ansible-lint || true
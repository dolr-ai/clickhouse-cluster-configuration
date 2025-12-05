#!/bin/bash

# Local script to run Ansible commands similar to GitHub CI workflow
# This mirrors the steps from .github/workflows/deploy-cluster.yml

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the ansible directory to ensure ansible.cfg and hosts.yml are found
cd "$SCRIPT_DIR"

echo "=== Local Ansible Deployment Script ==="
echo "Working directory: $(pwd)"
echo ""

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible is not installed. Please install it first:"
    echo "  pip install ansible ansible-core"
    exit 1
fi

echo "✓ Ansible is installed"
echo ""

# Set up SSH agent and add key
echo "Setting up SSH agent..."
eval "$(ssh-agent -s)"

# Add SSH key (assuming default location)
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add ~/.ssh/id_ed25519
    echo "✓ Added ~/.ssh/id_ed25519 to SSH agent"
elif [ -f ~/.ssh/id_rsa ]; then
    ssh-add ~/.ssh/id_rsa
    echo "✓ Added ~/.ssh/id_rsa to SSH agent"
else
    echo "Warning: No SSH key found at ~/.ssh/id_ed25519 or ~/.ssh/id_rsa"
    echo "You may need to specify the SSH key manually"
fi

echo ""

# Test Ansible connectivity (same as GitHub CI)
echo "Testing Ansible connectivity..."
ansible all -m ping -v

echo ""
echo "=== Connectivity test complete ==="

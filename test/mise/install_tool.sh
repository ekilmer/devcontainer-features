#!/bin/bash

set -e

source dev-container-features-test-lib

# Basic checks
check "mise cli installed" command -v mise
check "mise version" mise --version

# Verify the data directory is writable by the vscode user
check "mise data dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.local/share/mise | grep vscode"

# Install a tool to verify the full workflow works
check "mise install tool" mise install tiny@latest

reportResults

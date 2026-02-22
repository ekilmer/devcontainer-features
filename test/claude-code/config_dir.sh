#!/bin/bash

set -e

source dev-container-features-test-lib

# Basic checks
check "claude cli installed" command -v claude
check "claude version" claude --version

# Verify the config directory is writable by the vscode user
check "claude config dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.claude | grep vscode"

reportResults

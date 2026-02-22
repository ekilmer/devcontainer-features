#!/bin/bash

set -e

source dev-container-features-test-lib

# Basic checks
check "mise cli installed" command -v mise
check "mise version" mise --version

# Verify the volume mount and parent directories are owned by vscode
check "mise data dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.local/share/mise | grep vscode"
check ".local dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.local | grep vscode"
check ".local/share dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.local/share | grep vscode"

# Install cmake to verify the full workflow works end-to-end
check "mise install cmake" mise install cmake@latest
check "cmake available via shims" bash -c "mise exec cmake@latest -- cmake --version"

reportResults

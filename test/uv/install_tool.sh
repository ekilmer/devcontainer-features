#!/bin/bash

set -e

source dev-container-features-test-lib

# Basic checks
check "uv cli installed" command -v uv
check "uv version" uv --version

# Verify the cache and parent directories are owned by vscode
check ".cache dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.cache | grep vscode"
check "uv cache dir owned by vscode" bash -c "stat -c '%U' /home/vscode/.cache/uv | grep vscode"

# Verify the cache directory is writable
check "uv cache writable" bash -c "touch /home/vscode/.cache/uv/.write-test && rm /home/vscode/.cache/uv/.write-test"

reportResults

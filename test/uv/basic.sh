#!/bin/bash

set -e

# Test if uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv command not found"
    exit 1
fi

# Test version output
if ! uv --version; then
    echo "uv version check failed"
    exit 1
fi

# Test uvx is also available
if ! command -v uvx &> /dev/null; then
    echo "uvx command not found"
    exit 1
fi

echo "uv installation test passed!"
exit 0

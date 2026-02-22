#!/bin/bash

set -e

# Test if mise is installed
if ! command -v mise &> /dev/null; then
    echo "mise command not found"
    exit 1
fi

# Test version output
if ! mise --version; then
    echo "mise version check failed"
    exit 1
fi

echo "mise installation test passed!"
exit 0

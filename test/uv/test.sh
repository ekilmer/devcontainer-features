#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "uv cli installed" command -v uv
check "uv version" uv --version
check "uvx cli installed" command -v uvx
check "uvx version" uvx --version

# Report results
reportResults

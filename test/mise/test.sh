#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "mise cli installed" command -v mise
check "mise version" mise --version

# Report results
reportResults

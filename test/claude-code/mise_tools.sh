#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Claude Code should be installed
check "claude cli installed" command -v claude

# CLI tools installed via mise should be available
check "rg installed" command -v rg
check "fd installed" command -v fd
check "fzf installed" command -v fzf
check "jq installed" command -v jq
check "delta installed" command -v delta

# Report results
reportResults

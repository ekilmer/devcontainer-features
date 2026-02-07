#!/bin/sh
set -e

# Devcontainer features provide _REMOTE_USER and _REMOTE_USER_HOME
USERNAME="${_REMOTE_USER:-"$(whoami)"}"
USER_HOME="${_REMOTE_USER_HOME:-"$HOME"}"

# Check if claude is already installed
if command -v claude > /dev/null 2>&1; then
    echo "Claude Code is already installed: $(claude --version)"
    exit 0
fi

echo "Installing Claude Code CLI for user ${USERNAME}..."

# Ensure curl is available
if ! command -v curl > /dev/null 2>&1; then
    echo "Installing curl..."
    if command -v apt-get > /dev/null 2>&1; then
        apt-get update && apt-get install -y --no-install-recommends curl ca-certificates
    elif command -v apk > /dev/null 2>&1; then
        apk add --no-cache curl ca-certificates
    elif command -v dnf > /dev/null 2>&1; then
        dnf install -y curl ca-certificates
    elif command -v yum > /dev/null 2>&1; then
        yum install -y curl ca-certificates
    else
        echo "ERROR: curl is not installed and no supported package manager found."
        exit 1
    fi
fi

if [ "$(id -u)" = "0" ] && [ "${USERNAME}" != "root" ]; then
    # Running as root but installing for the non-root container user
    su - "${USERNAME}" -c "curl -fsSL https://claude.ai/install.sh | bash"
else
    curl -fsSL https://claude.ai/install.sh | bash
fi

# Symlink into /usr/local/bin so claude is on PATH in non-login shells
for dir in ".local/bin" ".claude/bin"; do
    if [ -x "${USER_HOME}/${dir}/claude" ]; then
        ln -sf "${USER_HOME}/${dir}/claude" /usr/local/bin/claude
        break
    fi
done

echo "Claude Code CLI installed successfully."

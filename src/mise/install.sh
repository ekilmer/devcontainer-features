#!/bin/sh
set -e

# Devcontainer features provide _REMOTE_USER and _REMOTE_USER_HOME
USERNAME="${_REMOTE_USER:-"$(whoami)"}"
USER_HOME="${_REMOTE_USER_HOME:-"$HOME"}"

# Check if mise is already installed
if command -v mise > /dev/null 2>&1; then
    echo "mise is already installed: $(mise --version)"
    exit 0
fi

echo "Installing mise for user ${USERNAME}..."

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
    su - "${USERNAME}" -c "curl -fsSL https://mise.run | sh"
else
    curl -fsSL https://mise.run | sh
fi

# Symlink into /usr/local/bin so mise is on PATH in non-login shells
if [ -x "${USER_HOME}/.local/bin/mise" ]; then
    ln -sf "${USER_HOME}/.local/bin/mise" "/usr/local/bin/mise"
fi

# Ensure the mise data directory is owned by the target user.
# The volume mount in devcontainer-feature.json creates this directory as root
# before the install script runs, so mise would get permission errors at runtime.
MISE_DATA_DIR="${USER_HOME}/.local/share/mise"
if [ -d "${MISE_DATA_DIR}" ] && [ "$(id -u)" = "0" ] && [ "${USERNAME}" != "root" ]; then
    chown -R "${USERNAME}" "${MISE_DATA_DIR}"
fi

echo "mise installed successfully."

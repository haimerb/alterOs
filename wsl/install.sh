#!/bin/bash
set -euo pipefail

DISTRO_NAME="alterOs"
DEFAULT_INSTALL_DIR="$HOME/alterOs"
TARBALL_PATH="../dist/alteros-kali-amd64-wsl.tar.gz"

if [ ! -f "$TARBALL_PATH" ]; then
    echo "Error: Tarball not found at $TARBALL_PATH"
    echo "Run ./scripts/build.sh first to create the distribution."
    exit 1
fi

read -p "Install directory [$DEFAULT_INSTALL_DIR]: " INSTALL_DIR
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"

mkdir -p "$INSTALL_DIR"

echo "Importing $DISTRO_NAME into WSL2..."
wsl --import "$DISTRO_NAME" "$INSTALL_DIR" "$TARBALL_PATH" --version 2

echo "Setting default user to root..."
wsl -d "$DISTRO_NAME" -u root -- bash -c "echo '[user]' > /etc/wsl.conf && echo 'default=root' >> /etc/wsl.conf"

echo "Starting distro for first boot setup..."
wsl -d "$DISTRO_NAME" -- bash -c "systemctl status" || true

echo ""
echo "=== Installation Complete ==="
echo "Run: wsl -d $DISTRO_NAME"
echo "Or:  wsl -d $DISTRO_NAME -u root"
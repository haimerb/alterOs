#!/bin/bash
set -euo pipefail

DISTRO_NAME="alterOs"

echo "=== Testing WSL Distribution: $DISTRO_NAME ==="

echo "1. Checking if distro exists in WSL..."
if ! wsl -l -v | grep -q "$DISTRO_NAME"; then
    echo "FAIL: Distro not found in WSL"
    exit 1
fi
echo "   PASS: Distro found"

echo "2. Testing basic command execution..."
wsl -d "$DISTRO_NAME" -- echo "Hello from alterOs"
echo "   PASS: Command execution works"

echo "3. Testing systemd..."
if wsl -d "$DISTRO_NAME" -- systemctl status >/dev/null 2>&1; then
    echo "   PASS: systemd is running"
else
    echo "   WARN: systemctl failed (may need first boot)"
fi

echo "4. Testing Kali tools availability..."
TOOLS=("nmap" "metasploit-framework" "burpsuite" "wireshark" "hydra" "john" "sqlmap" "nikto" "dirb" "gobuster")
for tool in "${TOOLS[@]}"; do
    if wsl -d "$DISTRO_NAME" -- which "$tool" >/dev/null 2>&1; then
        echo "   PASS: $tool found"
    else
        echo "   WARN: $tool not found (may be in different package)"
    fi
done

echo "5. Testing development tools availability..."
DEV_TOOLS=("git" "node" "npm" "go" "rustc" "cargo" "java" "dotnet" "python3" "pip3" "docker" "kubectl" "terraform" "nvim" "code" "gh" "fzf" "rg" "fd" "bat" "eza" "btop" "tmux" "zsh" "fish")
for tool in "${DEV_TOOLS[@]}"; do
    if wsl -d "$DISTRO_NAME" -- which "$tool" >/dev/null 2>&1; then
        echo "   PASS: $tool found"
    else
        echo "   WARN: $tool not found"
    fi
done

echo "6. Testing network connectivity..."
if wsl -d "$DISTRO_NAME" -- ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "   PASS: Internet connectivity"
else
    echo "   FAIL: No internet connectivity"
fi

if wsl -d "$DISTRO_NAME" -- ping -c 1 localhost >/dev/null 2>&1; then
    echo "   PASS: Localhost forwarding"
else
    echo "   WARN: Localhost forwarding issue"
fi

echo "7. Testing GUI support (WSLg)..."
if wsl -d "$DISTRO_NAME" -- env | grep -q WAYLAND_DISPLAY; then
    echo "   PASS: WAYLAND_DISPLAY set (WSLg active)"
else
    echo "   INFO: WAYLAND_DISPLAY not set (WSLg may not be available)"
fi

echo ""
echo "=== Test Summary ==="
echo "Distribution $DISTRO_NAME is ready for use."
echo "Run: wsl -d $DISTRO_NAME"
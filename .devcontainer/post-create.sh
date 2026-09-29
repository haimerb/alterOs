#!/bin/bash
set -euo pipefail

echo "=== alterOs DevContainer Post-Create Setup ==="

# Verify Docker-in-Docker is working
if docker info >/dev/null 2>&1; then
    echo "✓ Docker-in-Docker is running"
else
    echo "⚠ Docker-in-Docker not ready yet, starting..."
    sudo service docker start
    sleep 3
    if docker info >/dev/null 2>&1; then
        echo "✓ Docker-in-Docker started"
    else
        echo "✗ Docker-in-Docker failed to start"
    fi
fi

# Verify build tools
echo ""
echo "=== Build Tools Verification ==="
echo "live-build: $(lb --version 2>/dev/null || echo 'not found')"
echo "debootstrap: $(debootstrap --version 2>/dev/null | head -1 || echo 'not found')"
echo "docker: $(docker --version 2>/dev/null || echo 'not found')"

# Verify project structure
echo ""
echo "=== Project Structure ==="
ls -la /workspaces/alterOs/

# Show quick start
echo ""
echo "=== Quick Start ==="
echo "To build the distribution:"
echo "  cd /workspaces/alterOs && ./scripts/build.sh"
echo ""
echo "To test (requires WSL on host):"
echo "  ./scripts/test-wsl.sh"
echo ""
echo "Happy hacking! 🚀"
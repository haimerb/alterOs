#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$PROJECT_ROOT/config"
DIST_DIR="$PROJECT_ROOT/dist"

DISTRO_NAME="alteros"
ARCH="amd64"
# Kali uses 'kali-rolling' as its main distribution
SUITE="kali-rolling"
VARIANT="kali"

IMAGE_NAME="${DISTRO_NAME}-${VARIANT}-${ARCH}"
OUTPUT_TAR="${DIST_DIR}/${IMAGE_NAME}-wsl.tar.gz"

echo "=== Building ${IMAGE_NAME} ==="
echo "CONFIG_DIR: ${CONFIG_DIR}"
echo "DIST_DIR: ${DIST_DIR}"

mkdir -p "$DIST_DIR"

docker run --rm --privileged \
  -v "$CONFIG_DIR:/config" \
  -v "$DIST_DIR:/output" \
  -w /config \
  debian:bookworm-slim \
  /bin/bash -c "
    set -euo pipefail
    export DEBIAN_FRONTEND=noninteractive
    apt-get update && apt-get install -y live-build debootstrap curl gnupg2

    # Install Kali archive keyring - fetch and import the GPG key properly
    curl -fsSL https://archive.kali.org/archive-key.asc | gpg --dearmor -o /usr/share/keyrings/kali-archive-keyring.gpg
    
    # Add Kali repository with signed-by
    echo 'deb [signed-by=/usr/share/keyrings/kali-archive-keyring.gpg] https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware' > /etc/apt/sources.list.d/kali.list
    apt-get update
    apt-get install -y kali-archive-keyring

    # Configure live-build explicitly - Kali uses kali-rolling
    # Use only valid mirrors (no kali-rolling-updates, no kali-rolling-security)
    lb config noauto \
      --architectures '${ARCH}' \
      --distribution '${SUITE}' \
      --archive-areas 'main contrib non-free non-free-firmware' \
      --mirror-bootstrap 'https://http.kali.org/kali' \
      --mirror-chroot-security 'https://security.kali.org/kali-security' \
      --mirror-binary 'https://http.kali.org/kali' \
      --mirror-binary-security 'https://security.kali.org/kali-security' \
      --parent-mirror-bootstrap 'https://http.kali.org/kali' \
      --parent-mirror-chroot-security 'https://security.kali.org/kali-security' \
      --parent-mirror-binary 'https://http.kali.org/kali' \
      --parent-mirror-binary-security 'https://security.kali.org/kali-security' \
      --parent-archive-areas 'main contrib non-free non-free-firmware' \
      --bootappend-live 'boot=live components quiet splash' \
      --binary-images tar \
      --apt-indices false \
      --apt-recommends false \
      --security false \
      --updates false \
      --backports false

    lb build
    
    # Find the generated tarball (name may vary) and copy to output
    echo \"=== Looking for generated tarball ===\"
    find /config -name '*.tar.gz' -type f -ls
    echo \"=== All files in /config ===\"
    find /config -type f -name '*' | head -50
    find /config -name '*.tar.gz' -type f -exec cp {} /output/${IMAGE_NAME}-wsl.tar.gz \;
    echo \"=== Output directory contents ===\"
    ls -la /output/
  "

# Verify on host
echo "=== Host output directory contents ==="
ls -la "$DIST_DIR/"

echo "=== Build complete: ${OUTPUT_TAR} ==="
echo "Import into WSL with:"
echo "  wsl --import ${DISTRO_NAME} <install-path> ${OUTPUT_TAR} --version 2"
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$PROJECT_ROOT/config"
DIST_DIR="$PROJECT_ROOT/dist"

DISTRO_NAME="alteros"
ARCH="amd64"
SUITE="bookworm"
VARIANT="kali"

IMAGE_NAME="${DISTRO_NAME}-${VARIANT}-${ARCH}"
OUTPUT_TAR="${DIST_DIR}/${IMAGE_NAME}-wsl.tar.gz"

echo "=== Building ${IMAGE_NAME} ==="

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

    # Configure live-build explicitly
    lb config noauto \
      --architectures '${ARCH}' \
      --distribution '${SUITE}' \
      --archive-areas 'main contrib non-free non-free-firmware' \
      --mirror-bootstrap 'http://http.kali.org/kali' \
      --mirror-chroot-security 'http://security.kali.org/kali-security' \
      --mirror-binary 'http://http.kali.org/kali' \
      --mirror-binary-security 'http://security.kali.org/kali-security' \
      --parent-mirror-bootstrap 'http://http.kali.org/kali' \
      --parent-mirror-chroot-security 'http://security.kali.org/kali-security' \
      --parent-mirror-binary 'http://http.kali.org/kali' \
      --parent-mirror-binary-security 'http://security.kali.org/kali-security' \
      --parent-archive-areas 'main contrib non-free non-free-firmware' \
      --bootstrap-include 'apt-transport-https gnupg2' \
      --bootappend-live 'boot=live components quiet splash' \
      --binary-images tar \
      --apt-indices false \
      --apt-recommends false \
      --security true \
      --updates true \
      --backports false

    lb build
    mv live-image-${ARCH}.tar.gz /output/${IMAGE_NAME}-wsl.tar.gz
  "

echo "=== Build complete: ${OUTPUT_TAR} ==="
echo "Import into WSL with:"
echo "  wsl --import ${DISTRO_NAME} <install-path> ${OUTPUT_TAR} --version 2"
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
  -e "LB_BOOTSTRAP_INCLUDE=apt-transport-https gnupg" \
  -e "LB_MIRROR_BOOTSTRAP=http://http.kali.org/kali" \
  -e "LB_MIRROR_CHROOT_SECURITY=http://security.kali.org/kali-security" \
  -e "LB_MIRROR_BINARY=http://http.kali.org/kali" \
  -e "LB_MIRROR_BINARY_SECURITY=http://security.kali.org/kali-security" \
  -e "LB_ARCHITECTURES=${ARCH}" \
  -e "LB_DISTRIBUTION=${SUITE}" \
  -e "LB_ARCHIVE_AREAS=\"main contrib non-free non-free-firmware\"" \
  -e "LB_BOOTAPPEND_LIVE=\"boot=live components quiet splash\"" \
  -e "LB_BINARY_IMAGES=tar" \
  -e "LB_PARENT_MIRROR_BOOTSTRAP=http://http.kali.org/kali" \
  -e "LB_PARENT_MIRROR_CHROOT_SECURITY=http://security.kali.org/kali-security" \
  -e "LB_PARENT_MIRROR_BINARY=http://http.kali.org/kali" \
  -e "LB_PARENT_MIRROR_BINARY_SECURITY=http://security.kali.org/kali-security" \
  -e "LB_PARENT_ARCHIVE_AREAS=\"main contrib non-free non-free-firmware\"" \
  -w /config \
  debian:bookworm-slim \
  /bin/bash -c "
    apt-get update && apt-get install -y live-build debootstrap curl gnupg2 &&
    lb config &&
    lb build &&
    mv live-image-${ARCH}.tar.gz /output/${IMAGE_NAME}-wsl.tar.gz
  "

echo "=== Build complete: ${OUTPUT_TAR} ==="
echo "Import into WSL with:"
echo "  wsl --import ${DISTRO_NAME} <install-path> ${OUTPUT_TAR} --version 2"
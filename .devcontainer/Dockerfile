ARG VARIANT=bookworm
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    curl \
    gnupg2 \
    ca-certificates \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install additional tools for development
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    vim \
    zsh \
    jq \
    tree \
    htop \
    bat \
    eza \
    fzf \
    ripgrep \
    fd-find \
    && rm -rf /var/lib/apt/lists/*

# Set up zsh as default shell for vscode user
RUN chsh -s /bin/zsh vscode

# Create workspace directory
WORKDIR /workspaces/alterOs

# Copy build scripts for verification
COPY scripts/build.sh scripts/
COPY config/ config/
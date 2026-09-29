# alterOs - Kali Linux for WSL2

A custom Linux distribution based on Kali Linux tooling, optimized to run as a WSL2 distribution on Windows.

## Quick Start

### Prerequisites
- Windows 10/11 with WSL2 enabled
- Docker Desktop (for building)
- Git

### Build the Distribution

```bash
# Run in WSL2 or Linux environment with Docker
./scripts/build.sh
```

This creates `dist/alteros-kali-amd64-wsl.tar.gz`

### Install in Windows

```powershell
# In PowerShell (Run as Administrator)
wsl --import alterOs C:\Users\YourName\alterOs .\dist\alteros-kali-amd64-wsl.tar.gz --version 2
```

Or use the install script from WSL:
```bash
./wsl/install.sh
```

### Run

```bash
wsl -d alterOs
```

## What's Included

### Security Tools (Kali)
- **Kali Linux default tools** (`kali-linux-default` meta-package)
- **Additional tool categories**: Web, Wireless, Exploitation, Forensics, Reverse Engineering, Hardware, Passwords, Sniffing, Fuzzing, Crypto, SDR, VoIP, Windows Resources

### Development Environment (Ubuntu-style)
- **Build tools**: build-essential, cmake, gcc, g++, clang, llvm, make, pkg-config
- **Languages**: Python 3, Node.js, Go, Rust, Java 21, .NET 8
- **Version control**: git, git-lfs, gh (GitHub CLI), tig
- **Shell**: zsh (oh-my-zsh), fish, tmux, starship prompt
- **Editors**: neovim, VS Code (via code CLI)
- **Containers**: Docker, Podman, kubectl, helm, terraform
- **Databases**: PostgreSQL, MySQL, Redis, SQLite, MongoDB clients
- **Utilities**: fzf, ripgrep, fd, bat, eza, btop, httpie, jq, yq

### WSL Integration
- `wslu`, `systemd-genie`, systemd enabled
- Windows path interop, custom resolv.conf handling

## Project Structure

```
alterOs/
├── config/                 # live-build configuration
│   ├── package-lists/      # Tool packages to include
│   ├── includes.chroot/    # Files overlayed into rootfs
│   └── hooks/              # Build-time customization scripts
├── wsl/                    # WSL-specific configuration
│   ├── config.wsl          # WSL2 distro config
│   └── install.sh          # Windows installer script
├── scripts/                # Build automation
│   ├── build.sh            # Main build entrypoint
│   └── test-wsl.sh         # WSL validation
└── dist/                   # Build output (.tar.gz for WSL import)
```

## Testing

```bash
./scripts/test-wsl.sh
```

## Known Issues

- Build requires Docker and Linux kernel (run in WSL2 Ubuntu or GitHub Actions)
- First boot may take longer due to systemd initialization
- Some GUI tools require WSLg (Windows 11 or Windows 10 with KB5004296+)

## References

- [Kali live-build](https://gitlab.com/kalilinux/build-scripts/live-build-config)
- [WSL Custom Distro](https://docs.microsoft.com/windows/wsl/use-custom-distro)
- [Debian Debootstrap](https://wiki.debian.org/Debootstrap)
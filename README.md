# alterOs - Kali Linux + Dev Environment for WSL2

[![Build Status](https://github.com/haimerb/alterOs/actions/workflows/build-and-release.yml/badge.svg)](https://github.com/haimerb/alterOs/actions/workflows/build-and-release.yml)
[![Latest Release](https://img.shields.io/github/v/release/haimerb/alterOs)](https://github.com/haimerb/alterOs/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![WSL2](https://img.shields.io/badge/WSL2-Ready-blue)](https://docs.microsoft.com/windows/wsl/)

A custom Linux distribution combining **Kali Linux security tools** with a **full Ubuntu-style development environment**, optimized to run natively on **WSL2**.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Build Process (Docker)                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐ │
│  │  Debian     │───▶│  live-build │───▶│  alteros-wsl.tar.gz │ │
│  │  Bookworm   │    │  + Kali     │    │  (rootfs tarball)   │ │
│  │  Base       │    │  Repos      │    └──────────┬──────────┘ │
│  └─────────────┘    └─────────────┘               │            │
└───────────────────────────────────────────────────│────────────┘
                                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Runtime (WSL2 on Windows)                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  wsl --import alterOs ./install alteros-wsl.tar.gz --v2   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            │                                    │
│            ┌───────────────┼───────────────┐                    │
│            ▼               ▼               ▼                    │
│       ┌─────────┐    ┌───────────┐   ┌──────────┐              │
│       │  Kali   │    │   Dev     │   │   WSL    │              │
│       │ Tools   │    │  Stack    │   │  Config  │              │
│       │(nmap,   │    │(Python,  │   │(systemd, │              │
│       │ metasploit,         │   │ resolv,  │              │
│       │  burp,  │    │  Node,   │   │  interop)│              │
│       │  etc.)  │    │  Rust,   │   └──────────┘              │
│       └─────────┘    │  Go, etc) │                            │
│                      └───────────┘                            │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Option 1: Download Pre-built Release (Recommended)
1. Go to [Releases](https://github.com/haimerb/alterOs/releases/latest)
2. Download `alteros-kali-amd64-wsl.tar.gz`
3. Import to WSL:
```powershell
wsl --import alterOs C:\Users\YourName\alterOs .\alteros-kali-amd64-wsl.tar.gz --version 2
```

### Option 2: Build Locally (Docker Required)
```bash
# Prerequisites: Docker + Linux/WSL2
git clone https://github.com/haimerb/alterOs.git
cd alterOs
./scripts/build.sh
# Output: dist/alteros-kali-amd64-wsl.tar.gz

# Install
./wsl/install.sh
```

### Option 3: Develop in GitHub Codespaces / VS Code DevContainer
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/haimerb/alterOs)

1. Click the badge above or open in VS Code (`F1` → "Dev Containers: Reopen in Container")
2. Build inside container:
```bash
./scripts/build.sh
```

## What's Included

### 🔒 Security Tools (Kali)
| Category | Meta-package |
|----------|--------------|
| **Default** | `kali-linux-default` |
| **Web** | `kali-tools-web` |
| **Wireless** | `kali-tools-wireless` |
| **Exploitation** | `kali-tools-exploitation` |
| **Forensics** | `kali-tools-forensics` |
| **Reverse Engineering** | `kali-tools-reverse-engineering` |
| **Hardware** | `kali-tools-hardware` |
| **Passwords** | `kali-tools-passwords` |
| **Sniffing/Spoofing** | `kali-tools-sniffing-spoofing` |
| **Fuzzing** | `kali-tools-fuzzing` |
| **Crypto/Stego** | `kali-tools-crypto-stego` |
| **SDR/RFID/Bluetooth** | `kali-tools-sdr`, `kali-tools-rfid`, `kali-tools-bluetooth` |

### 💻 Development Environment
| Category | Tools |
|----------|-------|
| **Build** | `build-essential`, `cmake`, `gcc`, `g++`, `clang`, `llvm`, `meson`, `ninja`, `bazel` |
| **Languages** | Python 3.11, Node.js 20, Go 1.22, Rust 1.77, Java 21, .NET 8 |
| **Version Control** | `git`, `git-lfs`, `gh` (GitHub CLI), `tig` |
| **Shell** | `zsh` + Oh-My-Zsh, `fish`, `tmux`, `starship` prompt |
| **Editors** | `neovim` (preconfigured), `code` (VS Code CLI) |
| **Terminal** | `fzf`, `ripgrep`, `fd`, `bat`, `eza`, `btop`, `htop` |
| **Containers** | `docker`, `docker-compose`, `podman`, `kubectl`, `helm`, `terraform` |
| **Databases** | `postgresql-client`, `mysql-client`, `redis-tools`, `sqlite3`, `mongodb-clients` |
| **Web** | `nginx`, `apache2`, `certbot` |
| **Debug** | `gdb`, `valgrind`, `perf`, `strace`, `wireshark-cli` |

### 🔧 WSL Integration
- `systemd` enabled (services work natively)
- `wslu` utilities (`wslview`, `wslfetch`, etc.)
- Custom `config.wsl` (root user, no auto resolv.conf)
- Windows path interop (`/mnt/c/Users/...`)

## Terminal Preview

```bash
┌─[root@alterOs]─[~/projects]
└─╼ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified: config/package-lists/kali-tools.list.chroot

┌─[root@alterOs]─[~/projects]
└─╼ nmap --version
Nmap version 7.94SVN ( https://nmap.org )
```

## Project Structure

```
alterOs/
├── .github/workflows/        # CI/CD (GitHub Actions)
├── .devcontainer/            # VS Code / Codespaces dev environment
├── config/
│   ├── package-lists/        # Tool packages (kali-tools.list.chroot)
│   ├── includes.chroot/      # Files overlayed into rootfs
│   └── hooks/                # Build-time scripts (00-06 numbered)
├── wsl/
│   ├── config.wsl            # WSL2 distro configuration
│   └── install.sh            # Windows installer script
├── scripts/
│   ├── build.sh              # Main build entrypoint (Docker → live-build)
│   └── test-wsl.sh           # Post-install validation
├── dist/                     # Build output (.tar.gz) - gitignored
├── CONTRIBUTING.md           # Contribution guidelines
├── LICENSE                   # MIT License
└── README.md                 # This file
```

## Commands

| Command | Description |
|---------|-------------|
| `./scripts/build.sh` | Build distribution (requires Docker) |
| `./wsl/install.sh` | Interactive Windows installer |
| `./scripts/test-wsl.sh` | Validate installed distro |
| `wsl -d alterOs` | Launch distro |
| `wsl -d alterOs -u root` | Launch as root |

## Testing Checklist

After installation, run `./scripts/test-wsl.sh` to verify:

- [ ] Distro appears in `wsl -l -v`
- [ ] `systemctl status` works (systemd active)
- [ ] Kali tools available (nmap, metasploit, burpsuite, etc.)
- [ ] Dev tools available (git, node, go, rustc, docker, kubectl, nvim)
- [ ] Internet connectivity
- [ ] Localhost forwarding
- [ ] WSLg/Wayland support (GUI apps)

## Known Issues

- **Build requires Linux kernel**: Run `build.sh` in WSL2 Ubuntu, Linux VM, or GitHub Actions (not native Windows)
- **First boot delay**: systemd initialization takes 10-30s on first start
- **GUI apps**: Require WSLg (Windows 11+ or Win10 with KB5004296+)
- **Large image**: Full Kali + Dev ~4-6GB compressed, ~15GB expanded

## Releases

Pre-built tarballs available at [Releases](https://github.com/haimerb/alterOs/releases).

Version tags follow semantic versioning: `v1.0.0`, `v1.1.0`, etc.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Git workflow (branches, commits, PRs)
- How to add Kali tool categories
- How to add development tools
- Local testing procedures

## References

- [Kali live-build](https://gitlab.com/kalilinux/build-scripts/live-build-config)
- [WSL Custom Distro](https://docs.microsoft.com/windows/wsl/use-custom-distro)
- [Debian Debootstrap](https://wiki.debian.org/Debootstrap)
- [WSL Configuration](https://learn.microsoft.com/windows/wsl/wsl-config)

## License

MIT License - see [LICENSE](LICENSE) for details.
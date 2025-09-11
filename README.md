# Arch Linux Development Environment Setup

This Ansible playbook automates the complete setup of a fresh Arch Linux system with a comprehensive development environment.

## 🎯 What This Playbook Does

### System Packages
- **Base tools**: git, neovim, htop, base-devel, curl, wget, unzip
- **Network**: NetworkManager, openssh
- **Shell**: zsh with Oh My Zsh framework
- **Development**: rustup, nodejs, npm
- **Containerization**: docker, docker-compose, docker-buildx
- **Virtualization**: VirtualBox with kernel modules
- **Utilities**: ripgrep, fd, tree-sitter, gnome-disk-utility

### AUR Packages
- **Browsers**: Firefox Developer Edition, Google Chrome, Brave
- **Development**: pyenv (Python version manager)
- **Package manager**: paru (AUR helper)

### Development Environment
- **Node.js**: Version 24 via NVM (Node Version Manager)
- **Python**: Multiple versions (3.12.5, 3.11.9) via pyenv
- **Rust**: Stable toolchain with clippy and rustfmt
- **Shell**: Zsh with Oh My Zsh, autosuggestions, and syntax highlighting

### System Configuration
- **User management**: Proper group assignments (wheel, docker, audio, video, etc.)
- **Services**: Auto-enable Docker, NetworkManager, SSH
- **Shell environment**: Configured with aliases and environment variables
- **Security**: Proper sudo configuration

## 📋 Prerequisites

1. **Fresh Arch Linux installation** with base system
2. **User with sudo privileges** 
3. **Internet connection**
4. **Ansible installed**: `sudo pacman -S ansible`

## 🚀 Usage

### 1. Clone/Download this playbook
```bash
git clone <your-repo-url> ansible-arch-setup
cd ansible-arch-setup
```

### 2. Customize configuration (optional)
Edit `vars/main.yml` to customize:
- Username
- Package lists
- Node.js/Python versions
- Dotfiles repository URL

### 3. Run the playbook
```bash
ansible-playbook -i inventories/hosts.ini playbook.yml --ask-become-pass
```

You'll be prompted for your sudo password once at the beginning.

### 4. Restart terminal
After completion, restart your terminal or run:
```bash
source ~/.zshrc
```

## 📁 Project Structure

```
ansible-arch-setup/
├── playbook.yml              # Main playbook
├── inventories/
│   └── hosts.ini             # Inventory file
├── vars/
│   └── main.yml              # Configuration variables
└── roles/
    ├── users/                # User and sudo configuration
    ├── base/                 # System packages installation
    ├── shell/                # Zsh and Oh My Zsh setup
    ├── aur/                  # AUR packages and version managers
    ├── services/             # System services configuration
    ├── dotfiles/             # Personal dotfiles setup
    └── security/             # Final security configuration
```

## ⚙️ Configuration

### Main Configuration (`vars/main.yml`)

```yaml
# User configuration
username: r3tr0

# Node.js version
node_version: "24"

# Python versions
python_versions:
  - "3.12.5"
  - "3.11.9"

# Package lists
repo_packages: [...]
aur_packages: [...]

# Services to enable
services_to_enable:
  - NetworkManager
  - sshd
  - docker
```

### Dotfiles Integration
Set your dotfiles repository URL in `vars/main.yml`:
```yaml
dotfiles_repo: "https://github.com/yourusername/dotfiles.git"
```

## 🔧 Advanced Usage

### Run specific roles only
```bash
# Install only base packages
ansible-playbook -i inventories/hosts.ini playbook.yml --ask-become-pass --tags base

# Setup only shell configuration
ansible-playbook -i inventories/hosts.ini playbook.yml --ask-become-pass --tags shell
```

### Dry run (check mode)
```bash
ansible-playbook -i inventories/hosts.ini playbook.yml --ask-become-pass --check
```

### Verbose output
```bash
ansible-playbook -i inventories/hosts.ini playbook.yml --ask-become-pass -v
```

## 🎉 What You Get After Running

### Development Tools
- ✅ **Neovim** with aliases (vim → nvim)
- ✅ **Node.js 24** managed by NVM
- ✅ **Python 3.12.5 & 3.11.9** managed by pyenv
- ✅ **Rust stable** with development tools
- ✅ **Docker** with user permissions

### Browsers
- ✅ **Firefox Developer Edition**
- ✅ **Google Chrome**
- ✅ **Brave Browser**

### Shell Experience
- ✅ **Zsh** as default shell
- ✅ **Oh My Zsh** with robbyrussell theme
- ✅ **Auto-suggestions** and syntax highlighting
- ✅ **Smart completions** for Git, Docker, Node.js, Python, Rust

### System Services
- ✅ **Docker** running and enabled
- ✅ **NetworkManager** for network connectivity
- ✅ **SSH** server enabled
- ✅ **VirtualBox** kernel modules loaded

## 🛠️ Troubleshooting

### Permission Issues
If you encounter sudo password issues:
1. Verify your user is in the `wheel` group: `groups $USER`
2. Check sudo configuration: `sudo -l`

### Package Installation Failures
- **AUR packages**: Ensure paru is installed and working
- **System packages**: Check internet connection and mirror status

### Version Manager Issues
- **NVM**: Restart terminal and run `source ~/.zshrc`
- **pyenv**: Ensure development packages are installed for Python compilation

## 📝 Notes

- **Idempotent**: Safe to run multiple times
- **Secure**: Restores password-protected sudo after installation
- **Customizable**: Easy to modify package lists and configurations
- **Fresh install recommended**: Designed for clean Arch Linux installations

## 🤝 Contributing

Feel free to customize this playbook for your needs. Common modifications:
- Add/remove packages in `vars/main.yml`
- Modify zsh plugins in shell role
- Add custom dotfiles configuration
- Extend with additional development tools

## 📄 License

This playbook is provided as-is for educational and personal use.

---

**Enjoy your fully automated Arch Linux development environment!** 🚀

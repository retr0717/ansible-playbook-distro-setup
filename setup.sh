#!/bin/bash

# Arch Linux Setup Script
# Generated from Ansible playbook for r3tr0

set -e

USERNAME="r3tr0"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Arch Linux setup for user: $USERNAME${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print section headers
print_section() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Update system and install base packages
print_section "Installing base packages"
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    git neovim htop base-devel networkmanager docker docker-compose \
    docker-buildx virtualbox virtualbox-host-modules-arch \
    gnome-disk-utility rustup curl wget unzip openssh zsh net-tools \
    ripgrep fd tree-sitter nodejs npm

# Configure user groups
print_section "Configuring user groups"
sudo usermod -aG wheel,audio,video,optical,storage,docker $USERNAME

# Configure sudo
print_section "Configuring sudo access"
echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee' visudo -f /etc/sudoers.d/wheel

# Install Rust
print_section "Installing Rust toolchain"
if ! command_exists rustc; then
    rustup default stable
    rustup component add clippy rustfmt
fi

# Load VirtualBox modules
print_section "Loading VirtualBox kernel modules"
sudo modprobe vboxdrv || echo "VirtualBox module loading failed, continuing..."

# Install Oh My Zsh
print_section "Installing Oh My Zsh"
if [ ! -d "/home/$USERNAME/.oh-my-zsh" ]; then
    su - $USERNAME -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
fi

# Configure zsh
print_section "Configuring Zsh"
su - $USERNAME -c "
# Clone zsh plugins
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# Configure zsh plugins and theme
sed -i 's/^plugins=.*/plugins=(git sudo docker docker-compose rust node npm python pip virtualenv zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"robbyrussell\"/' ~/.zshrc

# Add environment variables
cat >> ~/.zshrc << 'EOF'

# NVM configuration
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"
[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\"

# Pyenv configuration
export PYENV_ROOT=\"\$HOME/.pyenv\"
export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
if command -v pyenv >/dev/null 2>&1; then
    eval \"\$(pyenv init -)\"
fi

# Rust configuration
export PATH=\"\$HOME/.cargo/bin:\$PATH\"

# Neovim aliases
alias vim=\"nvim\"
alias vi=\"nvim\"
export EDITOR=\"nvim\"
export VISUAL=\"nvim\"
EOF
"

# Change user shell to zsh
print_section "Changing user shell to zsh"
sudo chsh -s /bin/zsh $USERNAME

# Install paru (AUR helper)
print_section "Installing paru AUR helper"
if ! command_exists paru; then
    su - $USERNAME -c "
    cd /tmp
    rm -rf paru
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    "
fi

# Install AUR packages
print_section "Installing AUR packages"
su - $USERNAME -c "
export PATH=/usr/bin:\$PATH
paru -S --noconfirm --needed nvm firefox-developer-edition google-chrome brave-bin pyenv
"

# Setup Node.js with NVM
print_section "Installing Node.js 22 with NVM"
su - $USERNAME -c "
source ~/.zshrc
if [ -s \"\$NVM_DIR/nvm.sh\" ]; then
    source \"\$NVM_DIR/nvm.sh\"
    nvm install 22
    nvm use 22
    nvm alias default 22
fi
"

# Setup Python versions with pyenv
print_section "Installing Python versions with pyenv"
su - $USERNAME -c "
if command -v pyenv >/dev/null 2>&1; then
    eval \"\$(pyenv init -)\"
    pyenv install 3.12.5 || echo 'Python 3.12.5 installation failed, continuing...'
    pyenv install 3.11.9 || echo 'Python 3.11.9 installation failed, continuing...'
    pyenv global 3.12.5 || echo 'Setting global Python version failed, continuing...'
fi
"

# Enable services
print_section "Enabling system services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now sshd
sudo systemctl enable --now docker
sudo systemctl enable vboxdrv || echo "VirtualBox service enable failed, continuing..."

# Create neovim config directory
print_section "Setting up Neovim configuration"
su - $USERNAME -c "mkdir -p ~/.config/nvim"

# Restore secure sudo
print_section "Restoring secure sudo configuration"
sudo rm -f /etc/sudoers.d/wheel
echo '%wheel ALL=(ALL) ALL' | sudo EDITOR='tee' visudo -f /etc/sudoers.d/wheel

print_section "Setup Complete!"
echo -e "${GREEN}Your Arch Linux development environment is ready!${NC}"
echo -e "${YELLOW}Please restart your terminal or run 'source ~/.zshrc' to apply shell changes.${NC}"

# Create completion marker
touch /home/$USERNAME/.setup_complete

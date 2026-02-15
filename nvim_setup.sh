#!/bin/bash

################################################################################
# Neovim + LSP + Tools Complete Installation Script
# Works on Ubuntu/Debian-based systems
# Usage: sudo bash nvim-setup.sh
################################################################################

set -e  # Exit on error

echo "======================================"
echo "🚀 Neovim Complete Setup Script"
echo "======================================"
echo ""

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

################################################################################
# 1. SYSTEM UPDATES & LOCALE SETUP
################################################################################

echo ""
echo "📦 Step 1: System Update & Locale Setup"
echo "========================================"

apt update
log_info "System updated"

# Setup locale
apt install -y locales
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
log_info "Locale configured (en_US.UTF-8)"

################################################################################
# 2. CORE SYSTEM DEPENDENCIES
################################################################################

echo ""
echo "🔧 Step 2: Installing Core Dependencies"
echo "========================================"

apt install -y \
    build-essential \
    git \
    curl \
    wget \
    unzip \
    tar \
    gzip \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https

log_info "Core dependencies installed"

################################################################################
# 3. TERMINAL ENHANCEMENTS
################################################################################

echo ""
echo "🎨 Step 3: Terminal Enhancements"
echo "================================="

apt install -y \
    ncurses-term \
    xclip \
    wl-clipboard

echo 'export TERM=xterm-256color' >> ~/.bashrc
log_info "Terminal colors configured"

################################################################################
# 4. PYTHON SETUP
################################################################################

echo ""
echo "🐍 Step 4: Python Installation"
echo "==============================="

apt install -y \
    python3 \
    python3-pip \
    python3-venv

pip3 install --upgrade pip setuptools wheel
log_info "Python 3 installed and upgraded"

################################################################################
# 5. NODE.JS & NPM SETUP
################################################################################

echo ""
echo "📦 Step 5: Node.js & NPM Installation"
echo "======================================"

# Install Node.js from NodeSource repo (latest LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# Verify installation
node_version=$(node --version)
npm_version=$(npm --version)
log_info "Node.js $node_version installed"
log_info "NPM $npm_version installed"

# Upgrade NPM
npm install -g npm@latest
log_info "NPM upgraded to latest"

################################################################################
# 6. SEARCH & FIND TOOLS (Fuzzy Finder requirements)
################################################################################

echo ""
echo "🔍 Step 6: Installing Search & Find Tools"
echo "=========================================="

apt install -y ripgrep fd-find

# Create symlink for fd (Debian names it fdfind)
if command -v fdfind &> /dev/null; then
    ln -sf $(which fdfind) /usr/local/bin/fd
    log_info "fd-find linked to /usr/local/bin/fd"
fi

log_info "ripgrep and fd installed"

################################################################################
# 7. LUA DEVELOPMENT
################################################################################

echo ""
echo "🌙 Step 7: Lua Development Tools"
echo "==============================="

apt remove -y cargo rustc || true

curl https://sh.rustup.rs -sSf | sh -s -- -y

source "$HOME/.cargo/env"

rustup update
rustup default stable

apt install -y cargo

cargo install stylua

# ensure cargo bin path is available
export PATH="$HOME/.cargo/bin:$PATH"

apt install -y \
    lua5.1 \
    luarocks \

# Install Lua Language Server
if ! command -v lua-language-server &> /dev/null; then
    log_warn "Installing Lua Language Server..."
    apt install -y lua-language-server || true
fi

log_info "Lua tools installed"
################################################################################
# 8. CODE FORMATTERS & LINTERS
################################################################################

echo ""
echo "✨ Step 8: Code Formatters & Linters"
echo "====================================="

# Shell tools
apt install -y \
    shellcheck \
    shfmt

log_info "Shell tools installed (shellcheck, shfmt)"

# Python formatters & linters
pip3 install \
    black \
    flake8 \
    pylint \
    isort \
    yamllint

log_info "Python tools installed (black, flake8, pylint, isort, yamllint)"

# Prettier (JavaScript/JSON/Markdown)
npm install -g prettier

log_info "Prettier installed globally"

################################################################################
# 9. LANGUAGE SERVERS (LSP)
################################################################################

echo ""
echo "🗣️  Step 9: Language Servers Installation"
echo "=========================================="

# Kubernetes YAML (schema-aware)
npm install -g yaml-language-server

# Dockerfile
npm install -g dockerfile-language-server-nodejs

# Terraform
npm install -g terraform-ls

# AWS CloudFormation / SAM (Python-based)
pip3 install cfn-lint

# GitHub Actions
npm install -g @github-actions/languageserver

# Ansible
pip3 install ansible-language-server

# Helm (Kubernetes templating)
npm install -g @microsoft/helm-language-server


log_info "TypeScript Language Server installed"

# Python LSP servers
pip3 install \
    python-lsp-server \
    pyright

npm install -g pyright

log_info "Python LSP servers installed (pyright, python-lsp-server)"

# Bash Language Server
npm install -g bash-language-server

log_info "Bash Language Server installed"

# HTML/CSS/JSON Language Server
npm install -g vscode-langservers-extracted

log_info "VSCode Language Servers installed"

# Tree-sitter CLI
npm install -g tree-sitter-cli

log_info "Tree-sitter CLI installed"

################################################################################
# 10. NEOVIM INSTALLATION (Latest Release)
################################################################################

echo ""
echo "🎯 Step 10: Installing Latest Neovim"
echo "===================================="

# Download latest Neovim release
NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name": "\K[^"]+')
log_info "Latest Neovim version: $NVIM_VERSION"

# Download and install
mkdir -p /tmp/nvim
cd /tmp/nvim
wget -q https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage
chmod +x nvim.appimage

# Install to system
cp nvim.appimage /usr/local/bin/nvim
log_info "Neovim $NVIM_VERSION installed to /usr/local/bin/nvim"

# Verify installation
nvim --version | head -1
log_info "Neovim installed successfully!"

################################################################################
# 11. CREATE ALIAS
################################################################################

echo ""
echo "📝 Step 11: Creating Aliases"
echo "=============================="

# Add alias to bashrc
if ! grep -q "alias nv=" ~/.bashrc; then
    echo "alias nv='nvim'" >> ~/.bashrc
    log_info "Alias 'nv' added to ~/.bashrc"
else
    log_warn "Alias 'nv' already exists"
fi

# Add to zshrc if exists
if [ -f ~/.zshrc ]; then
    if ! grep -q "alias nv=" ~/.zshrc; then
        echo "alias nv='nvim'" >> ~/.zshrc
        log_info "Alias 'nv' added to ~/.zshrc"
    fi
fi

# Set alias for current session
alias nv='nvim'
log_info "Alias 'nv=nvim' set for current session"

################################################################################
# 12. COPY NEOVIM CONFIG
################################################################################

echo ""
echo "⚙️  Step 12: Neovim Configuration"
echo "===================================="

# Check if config exists in current user's home
if [ -d ~/.config/nvim ]; then
    log_warn "Neovim config already exists at ~/.config/nvim"
    read -p "Do you want to backup and replace? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv ~/.config/nvim ~/.config/nvim.backup.$(date +%s)
        log_info "Backed up old config to ~/.config/nvim.backup.*"
    fi
else
    mkdir -p ~/.config/nvim
    log_info "Created ~/.config/nvim directory"
fi

log_info "Neovim is ready to configure manually or copy your config"

################################################################################
# 13. VERIFICATION
################################################################################

echo ""
echo "✅ Step 13: Verification"
echo "========================"

echo ""
echo "Installed versions:"
echo "==================="

echo -n "Neovim: "
nvim --version | head -1

echo -n "Node.js: "
node --version

echo -n "NPM: "
npm --version

echo -n "Python: "
python3 --version

echo -n "Git: "
git --version

echo ""
echo "Language Servers:"
echo "================="

npm list -g --depth=0 2>/dev/null | grep -E "typescript|pyright|bash-language-server" || log_warn "Some LSPs may need verification"

echo ""
echo "Python packages:"
pip3 list | grep -E "black|flake8|pylint|pyright" || log_warn "Some Python tools may need verification"

################################################################################
# 14. FINAL SUMMARY
################################################################################

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        ✅ NEOVIM SETUP COMPLETE!                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "==========="
echo "1. Reload shell: source ~/.bashrc"
echo "2. Open Neovim: nv"
echo "3. Install plugins: :Lazy sync (in Neovim)"
echo ""
echo "Quick reference:"
echo "================"
echo "• Editor:        nv          (or nvim)"
echo "• Config dir:    ~/.config/nvim"
echo "• Data dir:      ~/.local/share/nvim"
echo "• Undo history:  ~/.local/share/nvim/undo"
echo ""
echo "Installed tools:"
echo "==============="
echo "✓ Neovim (latest)"
echo "✓ LSP Servers (TypeScript, Python, Bash, HTML/CSS/JSON)"
echo "✓ Formatters (black, prettier, shfmt, stylua)"
echo "✓ Linters (flake8, shellcheck, yamllint)"
echo "✓ Tree-sitter CLI"
echo "✓ Fuzzy finders (ripgrep, fd)"
echo ""
echo "To load aliases now, run:"
echo "  source ~/.bashrc"
echo ""


exit 0

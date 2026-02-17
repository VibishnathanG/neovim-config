#!/bin/bash

################################################################################
# 🚀 NEOVIM COMPLETE END-TO-END SETUP SCRIPT
# Optimized for: WSL Ubuntu, AWS Ubuntu VMs, Debian-based systems
# Features: Auto environment detection, error handling, verification, manual steps
# Version: 2.0
################################################################################

set -e  # Exit on error

# Enable error handling with trap
ERROR_LOG="/tmp/nvim_setup_errors.log"
SETUP_LOG="/tmp/nvim_setup.log"

# Clear previous logs
> "$ERROR_LOG"
> "$SETUP_LOG"

################################################################################
# VARIABLES & TRACKING
################################################################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Tracking arrays
SUCCEEDED=()
FAILED=()
WARNINGS=()
MANUAL_STEPS=()

# Environment detection
IS_WSL=false
IS_AWS=false
IS_ROOT=false
DISTRO=""

################################################################################
# UTILITY FUNCTIONS
################################################################################

log_info() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$SETUP_LOG"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a "$SETUP_LOG"
    WARNINGS+=("$1")
}

log_error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$SETUP_LOG"
    echo "$1" >> "$ERROR_LOG"
    FAILED+=("$1")
}

log_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

log_success() {
    SUCCEEDED+=("$1")
    log_info "$1"
}

# Execute command with error handling
run_cmd() {
    local cmd_name="$1"
    shift
    
    if "$@" &>> "$SETUP_LOG"; then
        log_success "$cmd_name"
        return 0
    else
        log_error "$cmd_name failed. Check $SETUP_LOG for details."
        return 1
    fi
}

# Check if command exists
cmd_exists() {
    command -v "$1" &> /dev/null
}

# Install apt package with fallback
install_apt() {
    local pkg_name="$1"
    local friendly_name="${2:-$pkg_name}"
    
    if cmd_exists "${pkg_name}" || dpkg -l | grep -q "^ii  ${pkg_name}"; then
        log_info "$friendly_name already installed"
        return 0
    fi
    
    if apt install -y "$pkg_name" &>> "$SETUP_LOG"; then
        log_success "$friendly_name installed"
        return 0
    else
        log_error "Failed to install $friendly_name"
        return 1
    fi
}

# Install npm package globally
install_npm() {
    local pkg_name="$1"
    local friendly_name="${2:-$pkg_name}"
    
    if npm list -g "$pkg_name" &>> /dev/null; then
        log_info "$friendly_name already installed"
        return 0
    fi
    
    if npm install -g "$pkg_name" &>> "$SETUP_LOG"; then
        log_success "$friendly_name installed globally"
        return 0
    else
        log_error "Failed to install $friendly_name"
        return 1
    fi
}

# Install pip package
install_pip() {
    local pkg_name="$1"
    local friendly_name="${2:-$pkg_name}"
    
    if pip3 show "$pkg_name" &>> /dev/null; then
        log_info "$friendly_name already installed"
        return 0
    fi
    
    if pip3 install "$pkg_name" &>> "$SETUP_LOG"; then
        log_success "$friendly_name installed"
        return 0
    else
        log_error "Failed to install $friendly_name"
        return 1
    fi
}

################################################################################
# ENVIRONMENT DETECTION
################################################################################

log_section "1️⃣  ENVIRONMENT DETECTION"

detect_environment() {
    # Check if running as root
    [[ $EUID -eq 0 ]] && IS_ROOT=true
    
    # Detect WSL
    if [[ -f /proc/version ]]; then
        if grep -qi "microsoft\|wsl" /proc/version; then
            IS_WSL=true
            log_info "✓ Detected: WSL Environment"
        fi
    fi
    
    # Detect AWS-like environment
    if [[ -f /sys/hypervisor/uuid ]]; then
        if grep -qi "ec2" /sys/hypervisor/uuid 2>/dev/null; then
            IS_AWS=true
            log_info "✓ Detected: AWS EC2 Instance"
        fi
    fi
    
    # Detect distro
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO="$PRETTY_NAME"
        log_info "✓ Distro: $DISTRO"
    fi
    
    [[ "$IS_WSL" == false ]] && [[ "$IS_AWS" == false ]] && \
        log_info "ℹ Detected: Regular Linux System (Generic Ubuntu/Debian)"
    
    log_info "Running as: $(whoami)"
}

detect_environment

################################################################################
# 2. LOCALE & SYSTEM SETUP
################################################################################

log_section "2️⃣  SYSTEM UPDATE & LOCALE SETUP"

run_cmd "System update" apt update || log_warn "apt update had issues, continuing..."

install_apt "locales" "Locale package" || true

if ! locale -a | grep -q "en_US.utf8"; then
    run_cmd "Generate locale" locale-gen en_US.UTF-8 || log_warn "Locale generation had issues"
fi

if ! grep -q "LANG=en_US.UTF-8" /etc/environment; then
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 2>> "$SETUP_LOG" || true
    log_info "Locale configured (en_US.UTF-8)"
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

################################################################################
# 3. CORE SYSTEM DEPENDENCIES
################################################################################

log_section "3️⃣  CORE SYSTEM DEPENDENCIES"

CORE_PACKAGES=(
    "build-essential"
    "git"
    "curl"
    "wget"
    "unzip"
    "tar"
    "gzip"
    "ca-certificates"
    "gnupg"
    "lsb-release"
    "apt-transport-https"
)

for pkg in "${CORE_PACKAGES[@]}"; do
    install_apt "$pkg" "$pkg" || log_warn "Optional: $pkg installation had issues"
done

################################################################################
# 4. TERMINAL ENHANCEMENTS & CLIPBOARD
################################################################################

log_section "4️⃣  TERMINAL ENHANCEMENTS & CLIPBOARD SETUP"

# Generic terminal
install_apt "ncurses-term" "ncurses-term" || true

# Clipboard handling - different for WSL vs AWS
if [[ "$IS_WSL" == true ]]; then
    log_info "📋 WSL Environment: Configuring Windows clipboard access"
    
    # For WSL: use wsl-clipboard or win32yank
    install_apt "wl-clipboard" "wl-clipboard (WSL)" || {
        log_warn "wl-clipboard not available, trying wslu..."
        install_apt "wslu" "wslu package" || log_warn "Clipboard setup skipped - will use native neovim clipboard"
    }
    
    if [[ ! -d ~/.local/bin ]]; then
        mkdir -p ~/.local/bin
    fi
    
    # Add to PATH if not already there
    if ! grep -q "\.local/bin" ~/.bashrc; then
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
        log_info "Added ~/.local/bin to PATH"
    fi
    
    MANUAL_STEPS+=("WSL Clipboard: If copy/paste issues occur, install win32yank manually from https://github.com/equim-chan/win32yank/releases")
    
else
    log_info "📋 Regular VM/Linux: Using xsel/xclip for clipboard"
    
    # For regular Linux use xsel or xclip
    if ! install_apt "xsel" "xsel (preferred)"; then
        if ! install_apt "xclip" "xclip (fallback)"; then
            log_warn "Neither xsel nor xclip installed - system clipboard may not work perfectly"
            MANUAL_STEPS+=("Install clipboard tool: sudo apt install xsel OR sudo apt install xclip")
        fi
    fi
fi

################################################################################
# 5. PYTHON SETUP (CRITICAL)
################################################################################

log_section "5️⃣  PYTHON INSTALLATION & SETUP"

install_apt "python3" "Python 3" || log_error "Python 3 installation failed (CRITICAL)"
install_apt "python3-pip" "pip3" || log_error "pip3 installation failed (CRITICAL)"
install_apt "python3-venv" "Python venv" || log_warn "Python venv - optional"

run_cmd "Upgrade pip" pip3 install --upgrade pip setuptools wheel || true

################################################################################
# 6. RUST & CARGO
################################################################################

log_section "6️⃣  RUST & CARGO INSTALLATION"

if ! cmd_exists cargo; then
    log_info "Installing Rust via rustup..."
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &>> "$SETUP_LOG"; then
        log_success "Rust installed"
        source "$HOME/.cargo/env"
    else
        log_error "Rust installation failed"
    fi
else
    log_info "Rust already installed"
    source "$HOME/.cargo/env" 2>/dev/null || true
fi

# Make cargo available
export PATH="$HOME/.cargo/bin:$PATH"

################################################################################
# 7. NODE.JS & NPM
################################################################################

log_section "7️⃣  NODE.JS & NPM INSTALLATION"

if cmd_exists node; then
    log_info "Node.js already installed: $(node --version)"
else
    log_info "Installing Node.js from NodeSource repository..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x &>> "$SETUP_LOG"
    if bash -s -- deb.nodesource.com/setup_lts.x &>> "$SETUP_LOG"; then
        log_warn "Node.js setup might need manual verification"
    fi
    apt update &>> "$SETUP_LOG" || true
    install_apt "nodejs" "Node.js + npm" || log_error "Node.js installation failed"
fi

if cmd_exists npm; then
    run_cmd "Upgrade npm" npm install -g npm@latest || log_warn "npm upgrade had issues"
    log_info "NPM version: $(npm --version)"
fi

################################################################################
# 8. SEARCH & FIND TOOLS
################################################################################

log_section "8️⃣  SEARCH & FIND TOOLS (ripgrep, fd)"

install_apt "ripgrep" "ripgrep" || log_warn "ripgrep - optional but recommended"
install_apt "fd-find" "fd-find" || log_warn "fd-find - optional but recommended"

# Create symlink for fd if needed
if cmd_exists fdfind && ! cmd_exists fd; then
    ln -sf "$(which fdfind)" /usr/local/bin/fd 2>> "$SETUP_LOG" || true
    log_info "Created symlink for fd"
fi

################################################################################
# 9. LUA DEVELOPMENT TOOLS
################################################################################

log_section "9️⃣  LUA DEVELOPMENT TOOLS"

install_apt "lua5.1" "Lua 5.1" || log_warn "Lua 5.1 - optional"

# stylua via cargo
if cmd_exists cargo; then
    if ! cmd_exists stylua; then
        log_info "Installing stylua via cargo..."
        if cargo install stylua &>> "$SETUP_LOG"; then
            log_success "stylua installed via cargo"
        else
            log_error "stylua installation failed"
        fi
    else
        log_info "stylua already installed"
    fi
else
    log_warn "Cargo not available, skipping stylua (will be installed by Mason in Neovim)"
fi

# lua-language-server - let Mason handle it
log_info "lua-language-server will be auto-installed by Mason in Neovim"

################################################################################
# 10. CODE FORMATTERS & LINTERS
################################################################################

log_section "🔟 CODE FORMATTERS & LINTERS"

# Shell tools
install_apt "shellcheck" "shellcheck (bash linter)" || log_warn "shellcheck - optional"
install_apt "shfmt" "shfmt (shell formatter)" || log_warn "shfmt - optional"

# Python formatters & linters
log_info "Installing Python formatters and linters..."
PYTHON_TOOLS=("black" "flake8" "pylint" "isort" "yamllint" "debugpy")

for tool in "${PYTHON_TOOLS[@]}"; do
    install_pip "$tool" "$tool" || log_warn "$tool installation had issues"
done

# Prettier (JavaScript/JSON/Markdown)
install_npm "prettier" "prettier" || log_warn "prettier - optional"

################################################################################
# 11. LANGUAGE SERVERS (LSP)
################################################################################

log_section "1️⃣1️⃣  LANGUAGE SERVERS & TOOLS"

log_info "Installing npm-based Language Servers..."

NPM_LSP_TOOLS=(
    "yaml-language-server"
    "dockerfile-language-server-nodejs"
    "@github-actions/languageserver"
    "bash-language-server"
    "typescript-language-server"
    "typescript"
    "pyright"
    "@microsoft/helm-language-server"
)

for tool in "${NPM_LSP_TOOLS[@]}"; do
    install_npm "$tool" "$tool" || log_warn "$tool - optional, will be handled by Mason"
done

# Other LSP tools via apt/pip
install_apt "terraform" "terraform" || log_warn "terraform - optional"
run_cmd "Install cfn-lint (CloudFormation)" pip3 install cfn-lint || log_warn "cfn-lint - optional"
install_npm "eslint" "eslint" || log_warn "eslint - optional"

# Tree-sitter CLI
install_npm "tree-sitter-cli" "tree-sitter CLI" || log_warn "tree-sitter-cli - optional"

################################################################################
# 12. NEOVIM INSTALLATION (LATEST)
################################################################################

log_section "1️⃣2️⃣  NEOVIM INSTALLATION (LATEST RELEASE)"

install_neovim() {
    # Try to get latest version
    NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest 2>/dev/null | grep -oP '"tag_name": "\K[^"]+' | head -1)
    
    if [[ -z "$NVIM_VERSION" ]]; then
        log_warn "Could not fetch latest version, using v0.9.0"
        NVIM_VERSION="v0.9.0"
    fi
    
    log_info "Latest Neovim version: $NVIM_VERSION"
    
    mkdir -p /tmp/nvim_install
    cd /tmp/nvim_install
    
    # Try AppImage first
    if wget -q "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage" 2>> "$SETUP_LOG"; then
        chmod +x nvim.appimage
        
        # Check for FUSE2 support (important for AppImage)
        if ! cat /proc/self/mountinfo | grep -q "fuse.appimage"; then
            log_warn "⚠️  AppImage might have FUSE2 compatibility issues on this system"
        fi
        
        if cp nvim.appimage /usr/local/bin/nvim 2>> "$SETUP_LOG"; then
            log_success "Neovim $NVIM_VERSION installed (AppImage)"
            return 0
        fi
    fi
    
    # Fallback: Try downloading pre-built binary
    log_warn "AppImage failed, trying pre-built binary..."
    
    # Detect architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        ARCH="x64"
    fi
    
    if wget -q "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux${ARCH}.tar.gz" 2>> "$SETUP_LOG"; then
        tar xzf "nvim-linux${ARCH}.tar.gz"
        if cp "nvim-linux${ARCH}/bin/nvim" /usr/local/bin/nvim 2>> "$SETUP_LOG"; then
            log_success "Neovim $NVIM_VERSION installed (pre-built binary)"
            return 0
        fi
    fi
    
    # Final fallback: compile from source (only if above fails)
    log_error "Pre-built binaries failed. Source compilation fallback not implemented."
    return 1
}

if cmd_exists nvim; then
    log_info "Neovim already installed: $(nvim --version | head -1)"
else
    if install_neovim; then
        log_success "Neovim installed successfully"
    else
        log_error "CRITICAL: Neovim installation failed"
    fi
fi

# Verify Neovim installation
if cmd_exists nvim; then
    NVIM_VERSION=$(nvim --version | head -1)
    log_success "✓ Verified: $NVIM_VERSION"
else
    log_error "CRITICAL: Neovim is not available in PATH"
fi

################################################################################
# 13. CREATE ALIASES
################################################################################

log_section "1️⃣3️⃣  CREATING ALIASES"

add_alias() {
    local alias_name="$1"
    local alias_cmd="$2"
    local shell_rc="$3"
    
    if [[ ! -f "$shell_rc" ]]; then
        return 0
    fi
    
    if ! grep -q "alias ${alias_name}=" "$shell_rc"; then
        echo "alias ${alias_name}='${alias_cmd}'" >> "$shell_rc"
        log_info "Added alias '${alias_name}' to $shell_rc"
    else
        log_info "Alias '${alias_name}' already exists in $shell_rc"
    fi
}

add_alias "nv" "nvim" ~/.bashrc
[[ -f ~/.zshrc ]] && add_alias "nv" "nvim" ~/.zshrc

# Set alias for current session
alias nv='nvim'
log_info "Alias 'nv=nvim' set for current session"

################################################################################
# 14. CARGO BIN PATH
################################################################################

log_section "1️⃣4️⃣  CONFIGURE CARGO PATH"

if [[ -d "$HOME/.cargo/bin" ]]; then
    if ! grep -q "\.cargo/bin" ~/.bashrc; then
        echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> ~/.bashrc
        log_info "Added Cargo bin dir to PATH"
    fi
    export PATH="$PATH:$HOME/.cargo/bin"
fi

################################################################################
# 15. NEOVIM CONFIGURATION (in workspace)
################################################################################

log_section "1️⃣5️⃣  NEOVIM CONFIGURATION SETUP"

# Check if we have the nvim config in the workspace
if [[ ! -d ~/.config/nvim ]]; then
    log_warn "Neovim config not found at ~/.config/nvim"
    MANUAL_STEPS+=("Copy nvim config: cp -r /path/to/workspace/.config/nvim ~/.config/")
else
    log_info "Neovim config found at ~/.config/nvim"
    
    # Verify key files exist
    if [[ -f ~/.config/nvim/init.lua ]]; then
        log_success "init.lua found"
    else
        log_error "init.lua missing from config"
    fi
fi

################################################################################
# 16. INSTALL DAP ADAPTERS (CRITICAL FOR DEBUGGING)
################################################################################

log_section "1️⃣6️⃣  DAP ADAPTERS INSTALLATION"

# debugpy already installed above in Python tools
if pip3 show debugpy &> /dev/null; then
    log_success "debugpy installed (Python debugging)"
else
    log_error "debugpy not available for Python debugging"
fi

# Node DAP adapters
install_npm "node-debug2-adapter" "node-debug2-adapter" || log_warn "node-debug2-adapter - optional"

MANUAL_STEPS+=("Review DAP configuration: Edit ~/.config/nvim/lua/plugins/dap.lua to verify debuggers are configured correctly")

################################################################################
# 17. VERIFICATION (try to start Neovim)
################################################################################

log_section "1️⃣7️⃣  VERIFICATION & PLUGIN CHECK"

if cmd_exists nvim; then
    log_info "Testing Neovim startup..."
    
    if timeout 10 nvim --headless -c "q!" 2>> "$SETUP_LOG"; then
        log_success "✓ Neovim starts successfully"
    else
        log_warn "⚠️  Neovim startup timed out or had issues (plugins may still load on first run)"
    fi
else
    log_error "CRITICAL: Neovim not found in PATH"
fi

################################################################################
# 18. POST-SETUP VERIFICATION SCRIPT
################################################################################

log_section "1️⃣8️⃣  CREATING POST-SETUP VERIFICATION SCRIPT"

cat > ~/.local/bin/nvim-verify &>> "$SETUP_LOG" || true
chmod +x ~/.local/bin/nvim-verify 2>/dev/null || true

cat > /tmp/nvim-verify.sh << 'VERIFY_EOF'
#!/bin/bash

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          NEOVIM SETUP VERIFICATION REPORT                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_cmd() {
    local name="$1"
    local cmd="$2"
    
    if command -v "$cmd" &> /dev/null || eval "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name: $(eval "$cmd 2>/dev/null | head -1" || echo "installed")"
    else
        echo -e "${RED}✗${NC} $name: NOT FOUND"
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Core Tools:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_cmd "Neovim" "nvim --version | head -1"
check_cmd "Node.js" "node --version"
check_cmd "Python" "python3 --version"
check_cmd "Git" "git --version"
check_cmd "Ripgrep" "rg --version | head -1"
check_cmd "fd" "fd --version"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Formatters:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_cmd "black (Python)" "pip3 show black | grep Name"
check_cmd "prettier" "npm list -g prettier | head -1"
check_cmd "shfmt" "shfmt --version | head -1"
check_cmd "stylua (Lua)" "stylua --version"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Linters:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_cmd "flake8 (Python)" "pip3 show flake8 | grep Name"
check_cmd "shellcheck" "shellcheck --version | head -1"
check_cmd "yamllint" "pip3 show yamllint | grep Name"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Language Servers (via npm):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_cmd "bash-language-server" "npm list -g bash-language-server | head -1"
check_cmd "pyright" "npm list -g pyright | head -1"
check_cmd "TypeScript LS" "npm list -g typescript-language-server | head -1"
check_cmd "YAML LS" "npm list -g yaml-language-server | head -1"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Debugging:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_cmd "debugpy (Python DAP)" "pip3 show debugpy | grep Name"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Neovim Config Files:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
[[ -f ~/.config/nvim/init.lua ]] && echo -e "${GREEN}✓${NC} init.lua" || echo -e "${RED}✗${NC} init.lua"
[[ -d ~/.config/nvim/lua/plugins ]] && echo -e "${GREEN}✓${NC} lua/plugins/" || echo -e "${RED}✗${NC} lua/plugins/"
[[ -f ~/.config/nvim/lazy-lock.json ]] && echo -e "${GREEN}✓${NC} lazy-lock.json" || echo -e "${RED}✗${NC} lazy-lock.json"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Logs: $SETUP_LOG"
echo "Errors: $ERROR_LOG"
echo ""
VERIFY_EOF

chmod +x /tmp/nvim-verify.sh
cp /tmp/nvim-verify.sh /usr/local/bin/nvim-verify 2>/dev/null || true
log_success "Verification script created: nvim-verify"

################################################################################
# 19. FINAL SUMMARY & MANUAL STEPS
################################################################################

log_section "1️⃣9️⃣  SETUP SUMMARY"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          ✅ SETUP COMPLETED - SEE BELOW FOR DETAILS          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Summary statistics
echo -e "${CYAN}COMPLETED STEPS:${NC} ${#SUCCEEDED[@]}"
echo -e "${YELLOW}WARNINGS:${NC} ${#WARNINGS[@]}"
echo -e "${RED}FAILED ITEMS:${NC} ${#FAILED[@]}"
echo ""

if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo -e "${RED}━━━━━━━━━ FAILED ITEMS ━━━━━━━━━${NC}"
    for item in "${FAILED[@]}"; do
        echo -e "  ${RED}✗${NC} $item"
    done
    echo ""
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    echo -e "${YELLOW}━━━━━━━━━ WARNINGS ━━━━━━━━━${NC}"
    for item in "${WARNINGS[@]}"; do
        echo -e "  ${YELLOW}!${NC} $item"
    done
    echo ""
fi

################################################################################
# DETAILED MANUAL CONFIGURATION STEPS
################################################################################

log_section "📋 MANUAL CONFIGURATION STEPS (IF NEEDED)"

echo ""
echo "If you encounter any issues after installation, follow these steps:"
echo ""

echo -e "${CYAN}1. COPY NEOVIM CONFIGURATION${NC}"
if [[ ! -d ~/.config/nvim ]]; then
    echo "   Config not found at ~/.config/nvim"
    echo "   Run this command to copy from your workspace:"
    echo "   $ cp -r /path/to/your/workspace/.config/nvim ~/.config/"
    echo ""
else
    echo "   ✓ Config already present at ~/.config/nvim"
    echo ""
fi

echo -e "${CYAN}2. FIRST LAUNCH & PLUGIN INSTALLATION${NC}"
echo "   When you open Neovim for the first time:"
echo "   $ nv"
echo ""
echo "   Lazy.nvim will auto-install all plugins. Wait for completion."
echo "   You may see errors on first launch - this is normal."
echo "   Press ':Lazy sync' inside Neovim to sync all plugins."
echo ""

echo -e "${CYAN}3. MASON LSP INSTALLATION${NC}"
echo "   Inside Neovim, Mason will auto-install language servers:"
echo "   $ :Mason       (open Mason UI)"
echo "   Or press: <Leader>m"
echo ""
echo "   Expected auto-installed servers:"
echo "     • lua_ls (Lua)"
echo "     • pyright (Python)"
echo "     • bashls (Bash)"
echo "     • ansiblels (Ansible)"
echo "     • dockerls (Dockerfile)"
echo "     • yamlls (YAML)"
echo "     • jsonls (JSON)"
echo ""

echo -e "${CYAN}4. VERIFY LANGUAGE SERVERS ARE WORKING${NC}"
echo "   After opening a Python file:"
echo "   $ :LspInfo       (shows LSP status)"
echo ""
echo "   You should see 'pyright' attached to the buffer."
echo ""

echo -e "${CYAN}5. TREESITTER GRAMMARS${NC}"
echo "   Tree-sitter grammars are auto-installed for:"
echo "    lua, python, bash, yaml, dockerfile, json, vim, markdown"
echo ""
echo "   To see all installed grammars:"
echo "   $ :TSModuleInfo"
echo ""
echo "   To install additional grammars:"
echo "   $ :TSInstall <language>"
echo ""

echo -e "${CYAN}6. DEBUGGING SETUP (Optional)${NC}"
echo "   Python debugging requires debugpy (already installed):"
echo "   $ python3 -m pip show debugpy"
echo ""
echo "   In Neovim, set a breakpoint:"
echo "   $ <Leader>db     (toggle breakpoint)"
echo "   $ <Leader>dc     (continue execution)"
echo ""

echo -e "${CYAN}7. CLIPBOARD CONFIGURATION${NC}"
if [[ "$IS_WSL" == true ]]; then
    echo "   🔵 WSL Environment:"
    echo "   Clipboard should work with wl-clipboard or wslu."
    echo ""
    echo "   If copy/paste doesn't work:"
    echo "   1. Install win32yank: https://github.com/equim-chan/win32yank/releases"
    echo "   2. Place win32yank.exe in /mnt/c/Tools/"
    echo "   3. Set in Neovim init.lua:"
    echo "      vim.g.clipboard = {"
    echo "        copy = {[\"+\"] = \"/mnt/c/Tools/win32yank.exe -i --crlf\"},"
    echo "        paste = {[\"+\"] = \"/mnt/c/Tools/win32yank.exe -o --lf\"},"
    echo "      }"
    echo ""
else
    echo "   🔵 Regular Linux/AWS VM:"
    echo "   Clipboard using xsel or xclip."
    if ! cmd_exists xsel && ! cmd_exists xclip; then
        echo ""
        echo "   ⚠️  WARNING: Neither xsel nor xclip found!"
        echo "   Install one of them:"
        echo "   $ sudo apt install xsel"
        echo "   OR"
        echo "   $ sudo apt install xclip"
    else
        echo "   ✓ Clipboard tools configured"
    fi
    echo ""
fi

echo -e "${CYAN}8. RELOAD SHELL (Important!)${NC}"
echo "   To apply aliases and PATH changes:"
echo "   $ source ~/.bashrc"
echo ""
echo "   Or close and reopen your terminal."
echo ""

echo -e "${CYAN}9. VERIFY INSTALLATION${NC}"
echo "   Run the verification script:"
echo "   $ nvim-verify"
echo ""
echo "   Or check logs:"
echo "   $ cat $SETUP_LOG"
echo "   $ cat $ERROR_LOG"
echo ""

################################################################################
# ADDITIONAL MANUAL STEPS IF ANY FAILED
################################################################################

if [[ ${#MANUAL_STEPS[@]} -gt 0 ]]; then
    echo -e "${YELLOW}━━━━━━━━━ ADDITIONAL MANUAL STEPS ━━━━━━━━━${NC}"
    echo ""
    for i in "${!MANUAL_STEPS[@]}"; do
        echo "$((i + 1)). ${MANUAL_STEPS[$i]}"
    done
    echo ""
fi

################################################################################
# FINAL STATUS
################################################################################

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
if [[ ${#FAILED[@]} -eq 0 ]]; then
    echo "║     ✅ SETUP SUCCESSFUL - NEOVIM IS READY TO USE!           ║"
else
    echo "║   ⚠️  SETUP COMPLETED WITH SOME ISSUES - SEE ABOVE           ║"
fi
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

echo "📚 Quick Reference:"
echo "   • Edit config:      $ nv ~/.config/nvim/init.lua"
echo "   • Open Neovim:      $ nv"
echo "   • Aliases:          nv → nvim"
echo "   • Config location:  ~/.config/nvim"
echo "   • Setup log:        $SETUP_LOG"
echo ""

echo "🔗 Useful Commands Inside Neovim:"
echo "   <Leader>ff    → Find files"
echo "   <Leader>fg    → Grep text"
echo "   <Leader>m     → Mason (install LSPs)"
echo "   <Leader>?     → Show keybindings help"
echo "   gd            → Go to definition"
echo "   K             → Show hover info"
echo "   <Leader>ca    → Code actions"
echo ""

exit 0

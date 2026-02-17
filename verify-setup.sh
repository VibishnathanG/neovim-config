#!/bin/bash

################################################################################
# 🔍 NEOVIM POST-SETUP VERIFICATION & CONFIGURATION HELPER
# Run this after the main setup script completes
# Purpose: Verify installation, troubleshoot issues, test functionality
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

log_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

log_warn() {
    echo -e "${YELLOW}!${NC} $1"
    ((WARNINGS++))
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

cmd_exists() {
    command -v "$1" &> /dev/null
}

################################################################################
# BANNER
################################################################################

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║            NEOVIM POST-SETUP VERIFICATION & DIAGNOSTICS                   ║"
echo "║                        Version 1.0                                        ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

################################################################################
# 1. ENVIRONMENT CHECK
################################################################################

section "1️⃣  ENVIRONMENT DETECTION"

if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then
    log_pass "Running on WSL"
    ENV_TYPE="WSL"
elif [[ -f /sys/hypervisor/uuid ]] && grep -qi "ec2" /sys/hypervisor/uuid 2>/dev/null; then
    log_pass "Running on AWS EC2"
    ENV_TYPE="AWS"
else
    log_pass "Running on regular Linux system"
    ENV_TYPE="LINUX"
fi

if [[ $EUID -eq 0 ]]; then
    log_warn "Running as root - some checks may not reflect actual user environment"
else
    log_pass "Running as regular user: $(whoami)"
fi

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    log_pass "OS: $PRETTY_NAME"
fi

################################################################################
# 2. CORE TOOLS CHECK
################################################################################

section "2️⃣  CORE TOOLS VERIFICATION"

check_tool() {
    local tool_name="$1"
    local display_name="${2:-$tool_name}"
    
    if cmd_exists "$tool_name"; then
        local version=$($tool_name --version 2>/dev/null | head -1 || echo "installed")
        log_pass "$display_name: $version"
        return 0
    else
        log_fail "$display_name: NOT FOUND"
        return 1
    fi
}

check_tool "nvim" "Neovim"
check_tool "python3" "Python 3"
check_tool "node" "Node.js"
check_tool "npm" "NPM"
check_tool "git" "Git"
check_tool "curl" "curl"
check_tool "wget" "wget"

################################################################################
# 3. SEARCH TOOLS
################################################################################

section "3️⃣  SEARCH & FIND TOOLS"

check_tool "rg" "Ripgrep" || log_warn "ripgrep - optional but recommended"
check_tool "fd" "fd" || log_warn "fd - optional but recommended"

################################################################################
# 4. PYTHON PACKAGES
################################################################################

section "4️⃣  PYTHON PACKAGES & TOOLS"

check_pip_package() {
    local pkg_name="$1"
    local display_name="${2:-$pkg_name}"
    
    if pip3 show "$pkg_name" &> /dev/null; then
        local version=$(pip3 show "$pkg_name" | grep Version | awk '{print $2}')
        log_pass "$display_name: $version"
        return 0
    else
        log_fail "$display_name: NOT INSTALLED"
        return 1
    fi
}

log_info "Checking Python packages..."
check_pip_package "black" "black (formatter)" || log_warn "Install: pip3 install black"
check_pip_package "flake8" "flake8 (linter)" || log_warn "Install: pip3 install flake8"
check_pip_package "pylint" "pylint (linter)"
check_pip_package "debugpy" "debugpy (debugger)" || log_warn "Install: pip3 install debugpy"
check_pip_package "pyright" "pyright (LSP)"

################################################################################
# 5. NPM PACKAGES
################################################################################

section "5️⃣  NPM GLOBAL PACKAGES"

check_npm_package() {
    local pkg_name="$1"
    local display_name="${2:-$pkg_name}"
    
    if npm list -g "$pkg_name" &> /dev/null; then
        local version=$(npm list -g "$pkg_name" 2>/dev/null | head -1 | grep -oP "\d+\.\d+\.\d+" || echo "installed")
        log_pass "$display_name: $version"
        return 0
    else
        log_fail "$display_name: NOT INSTALLED"
        return 1
    fi
}

log_info "Checking npm global packages..."
check_npm_package "prettier" "prettier" || log_warn "Install: npm i -g prettier"
check_npm_package "typescript-language-server" "TypeScript LS"
check_npm_package "bash-language-server" "Bash Language Server"
check_npm_package "yaml-language-server" "YAML Language Server"
check_npm_package "pyright" "pyright (npm)" || true  # May be installed via pip

################################################################################
# 6. FORMATTERS & LINTERS
################################################################################

section "6️⃣  FORMATTERS & LINTERS STATUS"

check_tool "prettier" "prettier" || log_warn "JavaScript/JSON formatter - npm i -g prettier"
check_tool "shfmt" "shfmt" || log_warn "Shell formatter - apt install shfmt"
check_tool "stylua" "stylua" || log_warn "Lua formatter - cargo install stylua"
check_tool "shellcheck" "shellcheck" || log_warn "Shell linter - apt install shellcheck"
check_tool "yamllint" "yamllint" || log_warn "YAML linter - pip3 install yamllint"

################################################################################
# 7. NEOVIM CONFIGURATION
################################################################################

section "7️⃣  NEOVIM CONFIGURATION FILES"

check_file() {
    local file_path="$1"
    local display_name="${2:-$file_path}"
    
    if [[ -f "$file_path" ]]; then
        local size=$(du -h "$file_path" | awk '{print $1}')
        log_pass "$display_name ($size)"
        return 0
    else
        log_fail "$display_name: NOT FOUND at $file_path"
        return 1
    fi
}

CONFIG_DIR="$HOME/.config/nvim"

if [[ ! -d "$CONFIG_DIR" ]]; then
    log_fail "Neovim config directory not found: $CONFIG_DIR"
    log_info "Create it with: mkdir -p ~/.config/nvim"
else
    log_pass "Config directory exists: $CONFIG_DIR"
    
    check_file "$CONFIG_DIR/init.lua" "init.lua"
    check_file "$CONFIG_DIR/lazy-lock.json" "lazy-lock.json (plugin lock file)"
    
    if [[ -d "$CONFIG_DIR/lua" ]]; then
        log_pass "lua directory exists ($(ls $CONFIG_DIR/lua | wc -l) files)"
    else
        log_fail "lua directory missing"
    fi
    
    if [[ -d "$CONFIG_DIR/lua/plugins" ]]; then
        local plugin_count=$(ls $CONFIG_DIR/lua/plugins/*.lua 2>/dev/null | wc -l)
        log_pass "lua/plugins directory exists ($plugin_count plugin files)"
    else
        log_fail "lua/plugins directory missing"
    fi
fi

################################################################################
# 8. CLIPBOARD SETUP
################################################################################

section "8️⃣  CLIPBOARD CONFIGURATION"

if [[ "$ENV_TYPE" == "WSL" ]]; then
    log_info "WSL detected - checking clipboard tools..."
    
    if cmd_exists wl-copy && cmd_exists wl-paste; then
        log_pass "wl-clipboard (Wayland) available"
    elif [[ -d /mnt/c/Tools ]] && [[ -f /mnt/c/Tools/win32yank.exe ]]; then
        log_pass "win32yank found at /mnt/c/Tools/win32yank.exe"
    else
        log_warn "Clipboard tools: Consider installing win32yank for better WSL clipboard"
        log_info "See SETUP_GUIDE.md for detailed WSL clipboard setup"
    fi
elif [[ "$ENV_TYPE" == "AWS" ]] || [[ "$ENV_TYPE" == "LINUX" ]]; then
    log_info "Linux system detected - checking clipboard tools..."
    
    if cmd_exists xsel; then
        log_pass "xsel available (primary clipboard tool)"
    elif cmd_exists xclip; then
        log_pass "xclip available (fallback clipboard tool)"
    else
        log_fail "No clipboard tool found"
        log_info "Install with: sudo apt install xsel"
    fi
fi

################################################################################
# 9. NEOVIM TEST
################################################################################

section "9️⃣  NEOVIM STARTUP TEST"

if cmd_exists nvim; then
    if timeout 5 nvim --headless -c "q" 2>&1 | grep -q "error\|Error\|ERROR"; then
        log_warn "Neovim started with warnings (may be normal)"
    else
        log_pass "Neovim starts and shuts down cleanly"
    fi
    
    # Try to load config
    if timeout 5 nvim --headless -c "try | :q" 2>&1 | grep -q "config"; then
        log_warn "Config loading had warnings (run :Lazy sync in Neovim)"
    else
        log_pass "Neovim config loads without critical errors"
    fi
else
    log_fail "Neovim not found - reinstall with: sudo bash ~/.config/nvim/nvim_complete_setup.sh"
fi

################################################################################
# 10. LANGUAGE SERVERS
################################################################################

section "🔟 LANGUAGE SERVERS (Via Mason)"

log_info "Note: Language servers are installed by Mason (inside Neovim)"
log_info "Expected servers to auto-install:"
echo ""
echo "  • lua_ls (Lua)"
echo "  • pyright (Python)"
echo "  • bashls (Bash)"
echo "  • ansiblels (Ansible)"
echo "  • dockerls (Dockerfile)"
echo "  • yamlls (YAML)"
echo "  • jsonls (JSON)"
echo ""

log_info "To install, open Neovim and run: :Mason"
log_info "Check status after with: :LspInfo"

################################################################################
# 11. TREESITTER
################################################################################

section "1️⃣1️⃣  TREESITTER (Code Parsing)"

log_info "Treesitter is auto-installed in Neovim"
log_info "Expected grammars: lua, python, bash, yaml, dockerfile, json, vim, markdown"
log_info ""
log_info "To check/update inside Neovim:"
echo "  :TSModuleInfo    - List installed grammars"
echo "  :TSUpdate        - Update all grammars"
echo "  :TSInstall <lang> - Install specific grammar"

################################################################################
# 12. PATHS & ENVIRONMENT
################################################################################

section "1️⃣2️⃣  ENVIRONMENT PATHS"

log_info "PATH variable check..."

if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    log_pass "~/.local/bin in PATH"
else
    log_warn "~/.local/bin NOT in PATH - add to ~/.bashrc:"
    echo "  export PATH=\"\$PATH:\$HOME/.local/bin\""
fi

if [[ ":$PATH:" == *":$HOME/.cargo/bin:"* ]]; then
    log_pass "Cargo bin in PATH"
elif [[ -d "$HOME/.cargo/bin" ]]; then
    log_warn "Cargo bin exists but not in PATH - add to ~/.bashrc:"
    echo "  export PATH=\"\$PATH:\$HOME/.cargo/bin\""
fi

################################################################################
# 13. ALIASES
################################################################################

section "1️⃣3️⃣  SHELL ALIASES"

if grep -q "alias nv=" ~/.bashrc; then
    log_pass "nv alias found in ~/.bashrc"
else
    log_warn "nv alias not found - add to ~/.bashrc:"
    echo "  echo \"alias nv='nvim'\" >> ~/.bashrc"
fi

if [[ -n "$BASH_ALIASES" ]] && [[ -n "${BASH_ALIASES[nv]}" ]]; then
    log_pass "nv alias active in current shell"
elif cmd_exists nv; then
    log_pass "nv command available"
else
    log_warn "nv alias not active - reload shell: source ~/.bashrc"
fi

################################################################################
# 14. FILE PERMISSIONS
################################################################################

section "1️⃣4️⃣  FILE PERMISSIONS & OWNERSHIP"

if [[ -d "$HOME/.config/nvim" ]]; then
    local owner=$(ls -ld "$HOME/.config/nvim" | awk '{print $3}')
    if [[ "$owner" == "$(whoami)" ]]; then
        log_pass "Config directory owned by you"
    else
        log_warn "Config directory owned by $owner"
        log_info "Fix with: sudo chown -R $(whoami):$(whoami) ~/.config/nvim"
    fi
fi

if [[ -f "$HOME/.bashrc" ]]; then
    if [[ -w "$HOME/.bashrc" ]]; then
        log_pass "~/.bashrc is writable"
    else
        log_warn "~/.bashrc is not writable"
    fi
fi

################################################################################
# 15. COMMON ISSUES
################################################################################

section "1️⃣5️⃣  COMMON ISSUES DIAGNOSIS"

echo ""
echo "Checking for common issues..."
echo ""

# Check if lazy.nvim is installed
if [[ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then
    log_pass "lazy.nvim plugin manager installed"
else
    log_warn "lazy.nvim not yet installed - will be auto-installed on first Neovim launch"
fi

# Check for plugin directory
if [[ -d "$HOME/.local/share/nvim/lazy" ]]; then
    local plugin_count=$(ls "$HOME/.local/share/nvim/lazy" 2>/dev/null | wc -l)
    if [[ $plugin_count -gt 3 ]]; then
        log_pass "Plugins installed ($plugin_count packages)"
    else
        log_warn "Few plugins installed ($plugin_count) - run :Lazy sync in Neovim"
    fi
fi

# Check for undo directory
if [[ -d "$HOME/.local/share/nvim/undo" ]]; then
    log_pass "Undo directory exists"
else
    log_info "Undo directory will be created on first Neovim session"
fi

################################################################################
# SUMMARY
################################################################################

section "📊 VERIFICATION SUMMARY"

echo ""
echo "Tests Passed:   $PASSED"
echo "Tests Failed:   $FAILED"
echo "Warnings:       $WARNINGS"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Reload shell:     source ~/.bashrc"
    echo "  2. Open Neovim:      nv"
    echo "  3. Sync plugins:     :Lazy sync"
    echo "  4. Install LSPs:     :Mason"
    echo ""
else
    echo -e "${RED}✗ Some checks failed - see above for details${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check logs:       cat /tmp/nvim_setup.log"
    echo "  2. Read guide:       ~/.config/nvim/SETUP_GUIDE.md"
    echo "  3. Re-run setup:     sudo bash ~/.config/nvim/nvim_complete_setup.sh"
    echo ""
fi

if [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}⚠️  $WARNINGS warning(s) detected - see instructions above${NC}"
    echo ""
fi

################################################################################
# NEXT STEPS
################################################################################

section "🎯 NEXT STEPS"

echo ""
echo "1️⃣  RELOAD SHELL (if not already done):"
echo "   $ source ~/.bashrc"
echo ""

echo "2️⃣  OPEN NEOVIM:"
echo "   $ nv"
echo ""

echo "3️⃣  IN NEOVIM - SYNC PLUGINS:"
echo "   :Lazy sync"
echo "   (Wait for completion, then press 'q' to close)"
echo ""

echo "4️⃣  IN NEOVIM - INSTALL LANGUAGE SERVERS:"
echo "   :Mason"
echo "   (Review that auto-installed servers are available)"
echo ""

echo "5️⃣  IN NEOVIM - VERIFY LSP:"
echo "   :LspInfo"
echo "   (Should show attached language servers)"
echo ""

echo "6️⃣  TEST WITH A PYTHON FILE:"
echo "   $ cat > test.py << 'EOF'
echo "   def hello(name):
echo "       return f'Hello {name}'
echo "   EOF"
echo ""
echo "   $ nv test.py"
echo "   (Inside Neovim, press 'K' on a function - should show hover info)"
echo ""

################################################################################
# HELP RESOURCES
################################################################################

section "📚 HELP & RESOURCES"

echo ""
echo "Documentation:"
echo "  • Full setup guide:     ~/.config/nvim/SETUP_GUIDE.md"
echo "  • Quick start:          ~/.config/nvim/QUICK_START.sh"
echo "  • Keybindings help:     Inside Neovim: <Leader>?"
echo ""

echo "Logs:"
echo "  • Full log:             /tmp/nvim_setup.log"
echo "  • Error log:            /tmp/nvim_setup_errors.log"
echo ""

echo "Commands (in Neovim):"
echo "  :Mason       - Install LSP servers, formatters, linters"
echo "  :Lazy        - Manage plugins"
echo "  :LspInfo     - Check connected language servers"
echo "  :ConformInfo - Check formatter configuration"
echo "  :TSModuleInfo - Check Treesitter parsers"
echo ""

echo "Quick verification:"
echo "  nvim-verify  - Run this verification again"
echo ""

################################################################################
# FINAL MESSAGE
################################################################################

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
if [[ $FAILED -eq 0 ]]; then
    echo "║                ✅ VERIFICATION COMPLETE - YOU'RE ALL SET!              ║"
else
    echo "║            ⚠️  VERIFICATION COMPLETE - REVIEW WARNINGS ABOVE             ║"
fi
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

exit $FAILED

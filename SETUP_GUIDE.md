# 🚀 Neovim Complete Setup - E2E Installation Guide

**Version:** 2.0  
**Last Updated:** February 17, 2026  
**Compatible With:**
- ✅ WSL (Windows Subsystem for Linux)
- ✅ AWS EC2 Ubuntu instances
- ✅ Regular Ubuntu/Debian Linux systems
- ✅ Any Debian-based distro

---

## 📋 Quick Start

### One-Command Installation

```bash
# Make script executable
chmod +x ~/.config/nvim/nvim_complete_setup.sh

# Run the setup
sudo bash ~/.config/nvim/nvim_complete_setup.sh
```

**Installation takes:** 15-30 minutes depending on internet speed and system specs.

---

## 🔍 What This Script Does

### ✅ Automatic Installation

1. **System Updates**: Updates package manager and configures locale
2. **Core Dependencies**: Installs git, curl, build tools
3. **Environment Detection**: Auto-detects WSL, AWS, regular Linux
4. **Clipboard Setup**: Configures appropriate clipboard for your environment
5. **Python 3**: Installs Python + pip + venv
6. **Rust & Cargo**: Installs Rust toolchain
7. **Node.js & NPM**: Latest LTS version + npm upgrade
8. **Search Tools**: ripgrep, fd (enhanced find/grep)
9. **Lua Development**: Lua 5.1, stylua formatter
10. **Formatters**: black (Python), shfmt (Bash), prettier (JS/JSON/YAML), stylua (Lua)
11. **Linters**: flake8 (Python), shellcheck (Bash), yamllint (YAML)
12. **Language Servers**: Installs ~10 npm-based LSP packages
13. **Neovim**: Latest release (AppImage or pre-built binary)
14. **Bash Aliases**: Creates `nv` alias for `nvim`
15. **DAP Debuggers**: Python debugging (debugpy) setup

### 📊 Error Handling

- **Graceful failures**: If one package fails, script continues
- **Detailed logging**: All output saved to `/tmp/nvim_setup.log`
- **Error isolation**: Failures tracked and reported at end
- **Warnings vs Errors**: Critical items fail the script, optional items warn only

---

## 🎯 Installation Steps

### Step 1: Prepare Your System

If you're on Ubuntu/Debian, start fresh:

```bash
# Update system (optional but recommended)
sudo apt update && sudo apt upgrade -y

# Clone/copy the nvim config to your home directory
# (If you don't already have it)
mkdir -p ~/.config
cp -r /path/to/workspace/.config/nvim ~/.config/
```

### Step 2: Run the Setup Script

```bash
# Navigate to the nvim config directory
cd ~/.config/nvim

# Make script executable
chmod +x nvim_complete_setup.sh

# Run with sudo (required for apt install)
sudo bash nvim_complete_setup.sh
```

**Note:** You may be prompted for your password. This is normal.

### Step 3: Watch the Installation

The script will:
- Display colored output with progress checks
- Show ✓ for successful steps
- Show ✗ for failed steps
- Show ! for warnings

Example output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ System updated
✓ Locale configured (en_US.UTF-8)
✓ build-essential installed
✓ git installed
✓ Python 3 installed and upgraded
! flake8 installation had issues, continuing...
✓ Rust installed
✓ Node.js 20.x installed
```

### Step 4: Reload Your Shell

After the script completes:

```bash
# Load aliases and path changes
source ~/.bashrc

# Verify Neovim is working
nv --version
```

---

## 📝 Post-Installation Configuration

### First Time Opening Neovim

```bash
# Open Neovim
nv

# Inside Neovim, wait for plugins to load...
# You should see messages about lazy.nvim installing plugins
# This may take 1-2 minutes on first launch
```

**Don't close Neovim during plugin installation!**

### Step 1: Sync Lazy.nvim Plugins

Inside Neovim, run:

```vim
:Lazy sync
```

Wait for all plugins to download. You may see warnings—they're usually fixed by the sync process.

### Step 2: Install Language Servers via Mason

Inside Neovim, open Mason:

```vim
:Mason
```

You should see a UI with available language servers. The config tries to auto-install these:

- ✅ lua_ls (Lua)
- ✅ pyright (Python)
- ✅ bashls (Bash)
- ✅ ansiblels (Ansible)
- ✅ dockerls (Dockerfile)
- ✅ yamlls (YAML)
- ✅ jsonls (JSON)

If any failed to auto-install, manually select them with `Enter` in the Mason UI.

### Step 3: Verify Language Servers Are Working

Open a Python file:

```bash
nv test.py
```

Inside Neovim:

```vim
:LspInfo
```

You should see output like:

```
Clients attached to this buffer:
  • pyright
```

To test code completion:
- Press `Ctrl+X Ctrl+O` (or let it autocomply as you type)
- You should see suggestions

### Step 4: Verify Debugging

Create a test Python script:

```bash
cat > test_debug.py << 'EOF'
def hello():
    x = 10  # Set breakpoint here
    y = 20
    return x + y

if __name__ == "__main__":
    result = hello()
    print(f"Result: {result}")
EOF
```

In Neovim:

```vim
:e test_debug.py
:34    # Go to line 34 (the x = 10 line)
<Leader>db  # Toggle breakpoint (should show a sign in left margin)
<Leader>dc  # Continue (start the debugger)
```

If you see the DAP UI with stack frames, debugging is working! ✓

---

## 🔧 Environment-Specific Configuration

### WSL Configuration

**WSL-Specific Features:**
- Uses `wl-clipboard` for copy/paste
- Falls back to `wslu` if wl-clipboard unavailable

**If clipboard doesn't work:**

1. Install win32yank:
   ```bash
   # Download from: https://github.com/equim-chan/win32yank/releases
   # Extract to: /mnt/c/Tools/win32yank.exe
   ```

2. Update `~/.config/nvim/init.lua`:
   ```lua
   vim.g.clipboard = {
     copy = {
       ["+"] = "/mnt/c/Tools/win32yank.exe -i --crlf",
       ["*"] = "/mnt/c/Tools/win32yank.exe -i --crlf",
     },
     paste = {
       ["+"] = "/mnt/c/Tools/win32yank.exe -o --lf",
       ["*"] = "/mnt/c/Tools/win32yank.exe -o --lf",
     },
     cache_enabled = 1,
   }
   ```

3. Reload Neovim:
   ```vim
   :q
   nv
   ```

### AWS EC2 Configuration

**AWS-Specific Considerations:**
- Uses `xsel` or `xclip` for clipboard
- Default SSH key authentication
- Instance may have limited resources

**If running on t2.micro (limited resources):**
- Plugin loading may be slower on first run
- Consider waiting longer for `:Lazy sync` to complete
- Tree-sitter compilation happens in background

**SSH Access from Neovim:**
```bash
# Edit remote files via scp://
nv scp://username@hostname:/path/to/file
```

### Regular Linux Systems

**Standard Configuration:**
- Uses `xsel` for clipboard
- All features available
- No special considerations needed

---

## ✅ Verification Checklist

Use the built-in verification script:

```bash
nvim-verify
```

This checks:
- ✓ Neovim installed
- ✓ All formatters available
- ✓ All linters available  
- ✓ Language servers installed
- ✓ Debugging tools available
- ✓ Config files present

**Expected output:**
```
✓ Neovim: v0.9.5
✓ Node.js: v20.11.1
✓ Python: 3.11.7
✓ Git: 2.45.2
✓ Ripgrep: 14.1.0
✓ fd: 10.1.0
✓ black: installed
✓ prettier: installed
✓ pyright: installed
...
```

**If something shows ✗:**
See the [Troubleshooting](#troubleshooting) section below.

---

## 🛠️ Troubleshooting

### Issue: Neovim won't start

**Symptoms:**
```
nvim: command not found
```

**Solution:**
1. Verify installation:
   ```bash
   ls -la /usr/local/bin/nvim
   ```

2. If file exists but command not found:
   ```bash
   hash -r  # Clear shell's command cache
   nv      # Try again
   ```

3. If file doesn't exist, reinstall:
   ```bash
   sudo bash ~/.config/nvim/nvim_complete_setup.sh
   ```

### Issue: Plugins won't load

**Symptoms:**
```
Error: Failed to load plugins
Lazy.nvim loading...
```

**Solution:**
1. Inside Neovim:
   ```vim
   :Lazy sync
   ```

2. Wait 2-3 minutes for all plugins to download

3. If still failing:
   ```bash
   rm -rf ~/.local/share/nvim/lazy/*
   nv
   # Let it reinstall everything
   ```

### Issue: Language servers not working

**Symptoms:**
- `:LspInfo` shows no attached clients
- No code completion

**Solution:**

1. Check if LSPs are installed:
   ```vim
   :Mason
   ```

2. Manually install missing servers:
   - Navigate with arrow keys
   - Press `i` to install
   - Or press `x` on installed ones to reinstall

3. After installing, reload Neovim:
   ```bash
   nv  # Close and reopen
   ```

4. Verify again:
   ```vim
   :LspInfo
   ```

### Issue: Formatting doesn't work

**Symptoms:**
- `:w` doesn't format code
- No formatter messages

**Solution:**

1. Check if formatters are installed:
   ```bash
   which black     # Python
   which shfmt     # Bash
   npm list -g prettier  # JS/JSON/YAML
   ```

2. Inside Neovim, verify conform setup:
   ```vim
   :ConformInfo
   ```

3. Manually format:
   ```vim
   :FormatWrite
   ```

If it works, the issue is likely the `format_on_save` hook. Check config.

### Issue: Debugging doesn't work

**Symptoms:**
- `<Leader>dc` doesn't start debugger
- No DAP UI appears

**Solution:**

1. Check if debugpy is installed:
   ```bash
   pip3 show debugpy
   ```

2. If not installed:
   ```bash
   pip3 install debugpy
   ```

3. Reload Neovim and try again:
   ```bash
   nv test.py
   <Leader>db  # Set breakpoint
   <Leader>dc  # Start debugging
   ```

### Issue: Clipboard not working

**Symptoms:**
- Copy/paste doesn't work between Neovim and system clipboard
- `:!pbpaste` doesn't work

**WSL Solution:**
- See [WSL Configuration](#wsl-configuration) above

**Regular Linux Solution:**
```bash
# Test if xsel works
echo "test" | xsel --clipboard --input
xsel --clipboard --output
```

If xsel doesn't work:
```bash
pip3 install clipboard
# Or install xclip as fallback
sudo apt install xclip
```

### Issue: Treesitter syntax errors

**Symptoms:**
- Error opening Markdown/Python files
- Treesitter warnings

**Solution:**

Inside Neovim:
```vim
:TSUpdate  # Update all treesitter parsers

:TSInstall python bash yaml markdown lua json  # Force reinstall
```

### Issue: Script failed with error

**Symptoms:**
- Setup script exited early
- Files at `/tmp/nvim_setup.log` and `/tmp/nvim_setup_errors.log` exist

**Solution:**

1. Check detailed error log:
   ```bash
   cat /tmp/nvim_setup_errors.log
   ```

2. Check full log:
   ```bash
   cat /tmp/nvim_setup.log | tail -50
   ```

3. Try to fix the issue and run again:
   ```bash
   sudo bash ~/.config/nvim/nvim_complete_setup.sh
   ```

4. If specific tool failed, install manually:
   ```bash
   # Example: if flake8 failed
   pip3 install flake8
   
   # Example: if prettier failed
   npm install -g prettier
   ```

---

## 📚 Essential Keybindings

### Editor Navigation
```vim
w      Jump to next word
b      Jump to previous word
^      Start of line
$      End of line
gg     Top of file
G      Bottom of file
%      Jump to matching bracket
{      Previous paragraph
}      Next paragraph
```

### Neovim-Specific (from custom config)
```vim
<Space>ff   Find files in project
<Space>fg   Grep text in project
<Space>FS   Find files in folder
<Space>e    Toggle file explorer
<A-h>       Horizontal split
<A-v>       Vertical split
<Leader>ca  Code actions
K           Hover information
gd          Go to definition
gr          Go to references
```

### Debugging
```vim
<Leader>db   Toggle breakpoint
<Leader>dc   Continue execution
<Leader>di   Step into
<Leader>do   Step over
<Leader>dout Step out
<Leader>dr   Open REPL
```

### Formatting & Linting
```vim
:FormatWrite        Format and save file
:ConformInfo        Show formatter info
:!flake8 %          Run flake8 on current file
```

---

## 🔄 Common Workflows

### Python Development

1. **Create a project:**
   ```bash
   mkdir my_project && cd my_project
   python3 -m venv venv
   source venv/bin/activate
   ```

2. **Open in Neovim:**
   ```bash
   nv app.py
   ```

3. **Add breakpoint and debug:**
   ```
   Set breakpoint: <Leader>db
   Run: <Leader>dc
   Step: <Leader>di
   ```

4. **Format and lint:**
   ```
   Format: :FormatWrite
   Lint: Set autocmd in config or use :!flake8 %
   ```

### Bash Script Development

1. **Create and open script:**
   ```bash
   nv deploy.sh
   ```

2. **Add shebang and write code:**
   ```bash
   #!/bin/bash
   # Your code here
   ```

3. **Format (requires shfmt):**
   ```
   :FormatWrite
   ```

4. **Check syntax:**
   ```
   :!shellcheck %
   ```

### YAML Configuration Files

1. **Edit config:**
   ```bash
   nv ansible-playbook.yml
   ```

2. **LSP provides validation automatically**

3. **Format:**
   ```
   :FormatWrite
   ```

---

## 🆘 Getting Help

### Check Logs

```bash
# Full installation log
cat /tmp/nvim_setup.log

# Errors only
cat /tmp/nvim_setup_errors.log

# Neovim specific
nv --version
nv --log-level DEBUG
```

### Run Verification

```bash
nvim-verify
```

### Manual Verification of Tools

```bash
# Check all tools individually
nv --version
python3 --version
node --version
git --version
black --version
prettier --version
flake8 --version
shellcheck --version

# Check if npm packages installed globally
npm list -g --depth=0 | grep -E "prettier|pyright|typescript"

# Check Python tools
pip3 list | grep -E "black|flake8|pylint|debugpy"
```

---

## 📦 What Gets Installed

### System Packages (apt)
- build-essential, git, curl, wget, unzip, tar, gzip
- locales, ncurses-term, xsel/xclip (or wl-clipboard for WSL)
- python3, python3-pip, python3-venv
- nodejs (via NodeSource LTS), npm
- ripgrep, fd-find
- lua5.1, lua-language-server (attempt)
- shellcheck, shfmt
- terraform (optional)

### Python Packages (pip3)
- black, flake8, pylint, isort, yamllint
- debugpy (Python debugger)
- pyright
- cfn-lint (AWS CloudFormation)

### NPM Packages (global)
- npm (latest)
- prettier
- yaml-language-server, dockerfile-language-server-nodejs
- bash-language-server, typescript-language-server
- pyright, typescript, @github-actions/languageserver
- tree-sitter-cli
- @microsoft/helm-language-server

### From Source
- Rust & Cargo (via rustup)
- stylua (Lua formatter, via cargo)
- Neovim (latest AppImage or pre-built binary)

### Neovim Plugins (via lazy.nvim)
See [Neovim Plugins](#neovim-plugins) below

---

## 🎨 Neovim Plugins

### UI & Navigation
- **kanagawa.nvim** - Beautiful colorscheme
- **nvim-tree.lua** - File explorer with icons
- **telescope.nvim** - Fuzzy finder for files/text
- **lualine.nvim** - Fast statusline
- **vim-visual-multi** - Multi-cursor editing

### Code Intelligence
- **nvim-lspconfig** - Language Server Protocol
- **mason.nvim** - LSP package manager
- **mason-lspconfig.nvim** - Mason + LSP integration
- **nvim-cmp** - Autocompletion engine
- **LuaSnip** - Snippet engine
- **friendly-snippets** - Snippet library

### Code Quality
- **conform.nvim** - Code formatter integration
- **nvim-lint** - Linter integration
- **nvim-treesitter** - Syntax highlighting & text objects
- **nvim-treesitter-textobjects** - Smart text selection

### Development Tools
- **nvim-dap** - Debug Adapter Protocol
- **nvim-dap-ui** - DAP user interface
- **gitsigns.nvim** - Git integration

---

## 🔐 Security Notes

### Safe Password Entry
- The script prompts for sudo password via system prompt (not visible)
- Your password is never logged or displayed

### Clipboard in WSL
- win32yank runs locally, doesn't send data anywhere
- wl-clipboard uses standard Linux clipboard protocol

### Code Execution
- All scripts are open source and readable
- Review before running: `cat ~/.config/nvim/nvim_complete_setup.sh`

---

## 🚀 Advanced Usage

### Activate Virtual Environment Automatically

Create `~/.config/nvim/venv.lua`:

```lua
-- Auto-detect Python venv
local function get_python_path()
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  return "/usr/bin/python3"
end

-- Set python path for Neovim
vim.g.python3_host_prog = get_python_path()
```

Load in `init.lua`:
```lua
require("venv")
```

### Customize Keybindings

Edit `~/.config/nvim/lua/keymaps.lua` and add your own:

```lua
vim.keymap.set("n", "<Leader>rf", function()
  vim.fn.system("python3 " .. vim.fn.expand("%"))
end, { noremap = true })
```

### Add Custom Language Server

Edit `~/.config/nvim/lua/plugins/lsp.lua`:

```lua
local servers = {
  "lua_ls",
  "pyright",
  "my_custom_server",  -- Add here
}
```

Then run `:Mason` to install.

---

## 📞 Support & Issues

If you encounter issues not covered above:

1. **Check the script output:**
   ```bash
   cat /tmp/nvim_setup.log
   ```

2. **Check Neovim logs:**
   ```bash
   nv
   :messages
   ```

3. **Run verification:**
   ```bash
   nvim-verify
   ```

4. **Manual fix and reinstall:**
   ```bash
   # Fix the specific issue
   pip3 install missing_package
   # Or
   npm install -g missing_package
   
   # Reload Neovim
   nv
   ```

---

## 📄 Files Created/Modified

**Main Script:**
- `/root/.config/nvim/nvim_complete_setup.sh` (this script)

**Logs (auto-generated):**
- `/tmp/nvim_setup.log` - Full installation log
- `/tmp/nvim_setup_errors.log` - Errors only

**Verification Script:**
- `/usr/local/bin/nvim-verify` - Run after installation

**Modified Config:**
- `~/.config/nvim/lua/plugins/dap.lua` - Added debugger configurations
- `~/.config/nvim/init.lua` - Already optimized
- `~/.config/nvim/keymaps.lua` - Already configured

---

## 🎯 Next Steps

1. **Run the setup script** ✓
2. **Reload your shell:** `source ~/.bashrc`
3. **Open Neovim:** `nv`
4. **Sync plugins:** `:Lazy sync` (inside Neovim)
5. **Install LSPs:** `:Mason` (inside Neovim)
6. **Start coding!** Open any Python/Bash/YAML file

---

**Happy coding! 🚀**

---

*For the latest updates and issues, check the setup logs at `/tmp/nvim_setup.log`*

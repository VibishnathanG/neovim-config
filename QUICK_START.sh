#!/bin/bash

################################################################################
# 📋 NEOVIM SETUP - QUICK REFERENCE CARD
# Print this out or save as bookmark
################################################################################

cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                     NEOVIM COMPLETE SETUP - QUICK START                   ║
╚════════════════════════════════════════════════════════════════════════════╝

📦 INSTALLATION (5 MINUTES)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Make script executable:
   $ chmod +x ~/.config/nvim/nvim_complete_setup.sh

2. Run setup (requires sudo):
   $ sudo bash ~/.config/nvim/nvim_complete_setup.sh

3. Wait for completion (shows ✓ for each step)

4. Reload shell:
   $ source ~/.bashrc

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚙️  FIRST-TIME SETUP (IN NEOVIM)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Open Neovim:
   $ nv

2. Wait for plugins to load (1-2 minutes)

3. Sync plugins:
   :Lazy sync
   (Press 'q' after done)

4. Open Mason to install language servers:
   :Mason
   (Auto-installs: lua_ls, pyright, bashls, yamlls, jsonls, etc.)

5. Verify LSPs are working:
   :LspInfo
   (Should show "pyright" for Python files, etc.)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 EDITOR KEYBINDINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File Navigation:
  <Space>ff  →  Find files in project
  <Space>fg  →  Grep (search) in project
  <Shift>E   →  Toggle file explorer
  <A-Home>   →  Toggle browser panel

Editing:
  <A-F>      →  Multi-cursor replace
  Ctrl+A     →  Select all
  <Leader>ca →  Code actions (fix errors)

Debugging (Python/Bash):
  <Leader>db  →  Toggle breakpoint
  <Leader>dc  →  Start/continue debugger
  <Leader>di  →  Step into function
  <Leader>do  →  Step over line
  <Leader>dout →  Step out of function

Window Management:
  <A-H>      →  Horizontal split
  <A-V>      →  Vertical split
  <C-w>w     →  Switch to next window

LSP (Language Server):
  K          →  Hover information
  gd         →  Go to definition
  gr         →  Go to references
  <Leader>ca →  Code actions

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Check installation:
$ nvim-verify

Full log:
$ cat /tmp/nvim_setup.log

Errors only:
$ cat /tmp/nvim_setup_errors.log

Neovim version:
$ nv --version

Language servers:
$ nv
  :LspInfo

Formatters:
$ nv
  :ConformInfo

Tree-sitter:
$ nv
  :TSModuleInfo

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🐛 DEBUGGING SETUP (PYTHON)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Create test file:
   $ cat > test.py << 'PYTHON'
   def hello(name):
       x = 10  # Line to debug
       return f"Hello {name}"
   
   if __name__ == "__main__":
       result = hello("World")
       print(result)
   PYTHON

2. Open in Neovim:
   $ nv test.py

3. Set breakpoint on line 2:
   - Go to line: :2
   - Toggle breakpoint: <Leader>db
   - (You should see • symbol in margin)

4. Start debugger:
   <Leader>dc
   (DAP UI window opens)

5. Debug commands:
   <Leader>dc = Continue
   <Leader>di = Step into
   <Leader>do = Step over
   <Leader>dout = Step out

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  COMMON ISSUES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Issue: "nvim: command not found"
Fix:   source ~/.bashrc
       hash -r
       nv

Issue: Plugins won't load
Fix:   :Lazy sync
       (Wait 2-3 minutes)

Issue: Language servers not showing
Fix:   :Mason
       Select missing servers and install
       (Restart Neovim: :q then nv)

Issue: Formatting doesn't work
Fix:   :ConformInfo
       (Check if formatter is installed)
       pip3 install black
       npm install -g prettier

Issue: Clipboard not working (WSL)
Fix:   Install win32yank from:
       https://github.com/equim-chan/win32yank
       Place at: /mnt/c/Tools/win32yank.exe

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🆘 HELP & LOGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Setup logs:
  /tmp/nvim_setup.log
  /tmp/nvim_setup_errors.log

Help inside Neovim:
  <Leader>?    (shows all keybindings)
  :help        (Neovim built-in help)
  :Mason       (install LSPs/formatters/linters)
  :Lazy        (manage plugins)

Verification:
  nvim-verify

📖 Full guide:
  ~/.config/nvim/SETUP_GUIDE.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 SUPPORTED ENVIRONMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ WSL (Windows Subsystem for Linux)
   - Auto-detects and uses wl-clipboard
   - Falls back to wslu/win32yank if needed

✅ AWS EC2 Ubuntu Instances
   - Auto-detects and uses xsel/xclip
   - Optimized for t2.micro to large instances

✅ Regular Ubuntu/Debian Systems
   - Standard clipboard with xsel/xclip
   - All features available

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 INSTALLED COMPONENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Neovim (latest)
✓ Python 3 + pip + venv
✓ Node.js LTS + npm
✓ Rust + Cargo
✓ Search tools (ripgrep, fd)
✓ Formatters (black, prettier, shfmt, stylua)
✓ Linters (flake8, shellcheck, yamllint)
✓ Language Servers (lua_ls, pyright, bashls, etc.)
✓ Debugging (debugpy for Python)
✓ Git + Fuzzy finder (telescope)
✓ File explorer (nvim-tree)
✓ 25+ Neovim plugins (via lazy.nvim)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 PRO TIPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Use 'nv' alias instead of 'nvim':
   $ nv myfile.py

2. Create virtual environment:
   $ python3 -m venv venv
   $ source venv/bin/activate
   (Neovim auto-detects and uses it)

3. Open help panel:
   Inside Neovim: <Leader>?
   (Shows custom keybindings)

4. Manage plugins quickly:
   :Lazy update   (update all plugins)
   :Lazy sync     (sync after config change)
   :Lazy clean    (remove unused plugins)

5. Use telescope for everything:
   :Telescope find_files
   :Telescope live_grep
   :Telescope help_tags

6. LSP quick navigation:
   Ctrl+] inside Neovim goes to definition
   gd = go definition
   gr = go references

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ You're all set! Open Neovim and start coding! ✨

$ nv

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

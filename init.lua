vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")
require("plugins")

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local is_wsl = vim.fn.has("wsl") == 1
local is_ssh = vim.env.SSH_CONNECTION ~= nil

local has_display = vim.env.DISPLAY and vim.env.DISPLAY ~= ""
local has_wayland = vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= ""

if is_ssh then
  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    name = "OSC52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = function()
        return { vim.fn.getreg('"'), vim.fn.getregtype('"') }
      end,
      ["*"] = function()
        return { vim.fn.getreg('"'), vim.fn.getregtype('"') }
      end,
    },
  }
elseif has_wayland and executable("wl-copy") and executable("wl-paste") then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy --primary",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste --primary",
    },
    cache_enabled = 0,
  }
elseif has_display and executable("xclip") then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o",
    },
    cache_enabled = 0,
  }
end

local function show_help()
  local help_text = {
    "╔════════════════════════════════════════════════════════════╗",
    "║      NEOVIM KEYBINDINGS REFERENCE - CUSTOM (Quick)        ║",
    "╚════════════════════════════════════════════════════════════╝",
    " ",
    "FILE NAVIGATION:",
    "  Shift+E              → Toggle file explorer (NvimTree)",
    "  Shift+FF             → Find files in project",
    "  Shift+FG             → Grep text in project",
    "  Shift+CF             → Find files in current folder",
    "  Shift+FH             → Find files in HOME directory",
    "  Shift+FS             → Find files in chosen folder",
    "  Shift+TS             → Grep text in chosen folder",
    "  Shift+Home           → Toggle file tree",
    "  Alt+Home             → Toggle telescope (search only)",
    "   q                   → Delete line/selection (no yank)",
    "  Alt+↑                → Move current line/selection up",
    "  Alt+↓                → Move current line/selection down",
    "   gc                  → Comment and un Comment Lines works with Normal and Visual Mode",
    " ",
    "EDITING & SELECTION:",
    "  Ctrl+A               → Select all",
    "  Ctrl+C               → Copy all",
    "  Ctrl+Shift+C         → Yank current line (system clipboard)",
    "  Ctrl+X               → Cut all",
    "  Ctrl+Z               → Delete all (no yank)",
    "  Alt+F                → Replace everywhere (buffer-wide)",
    "  Ctrl+/               → Toggle comment (line) — filetype-aware",
    "  Alt+Shift+L         → Toggle comment (filetype-aware) — works in insert/normal",
    " ",
    "WINDOW MANAGEMENT:",
    "  Alt+Shift+V (Alt+V)  → Vertical split",
    "  Alt+Shift+H (Alt+H)  → Horizontal split",
    "  Shift+PageUp         → Previous window",
    "  Shift+PageDown       → Next window",
    "  Home                 → Jump back to editor",
    "  Alt+T                → Toggle terminal",
    "  Ctrl+W Ctrl+Q        → Close current window",
    "  Ctrl+W =             → Equal window sizes",
    " ",
    "NAVIGATION:",
    "  PageUp               → Jump to top of file",
    "  PageDown             → Jump to last empty line",
    "  Alt+Left             → Start of line",
    "  Alt+Right            → End of line",
    "  Ctrl+Home            → Jump to beginning of file",
    "  Ctrl+End             → Jump to end of file",
    "  Ctrl+G               → Go to line number (now works in insert/visual)",
    " ",
    "FORMATTING:",
    "  Visual >             → Indent right (repeatable)",
    "  Visual <             → Indent left (repeatable)",
    "  Alt+=                → Auto-format selection",
    " ",
    "UTILITIES:",
    "  Shift+D T            → Toggle diagnostics (global)",
    "  Shift+D L            → Open diagnostics list (location list)",
    "  Alt+E                → Toggle error display (alternate)",
    "  Ctrl+L               → Clear highlights",
    "  Ctrl+S               → Save current file",
    " ",
    "SESSION CONTROL:",
    "  Shift+Z              → Quit all without saving (force)",
    "  Shift+S              → Save all and quit",
    " ",
    "DELETE (no clipboard):",
    "  d, D, x, c           → Delete without clipboard",
    " ",
    "F1                   → Show this help",
    " ",
    "● Safety notes: Shift+Z will close Neovim without writing any buffers. Use carefully.",
    "● Clipboard notes: Ctrl+Shift+C/X use the system clipboard (+ register).",
    " ",
    "╔════════════════════════════════════════════════════════════╗",
    "║            GENERIC NEOVIM SHORTCUTS (Built-in)             ║",
    "╚════════════════════════════════════════════════════════════╝",
    " ",
    "MOVEMENT:",
    "  h, j, k, l           → Move cursor (left, down, up, right)",
    "  w                    → Jump to next word",
    "  b                    → Jump to previous word",
    "  e                    → Jump to end of word",
    "  0                    → Jump to beginning of line",
    "  $                    → Jump to end of line",
    "  ^                    → Jump to first non-blank character",
    "  gg                   → Jump to first line",
    "  G                    → Jump to last line",
    "  f{char}              → Find character forward",
    "  F{char}              → Find character backward",
    "  t{char}              → Till character forward",
    "  T{char}              → Till character backward",
    "  ;                    → Repeat last f/F/t/T",
    "  ,                    → Repeat last f/F/t/T in opposite direction",
    "  %                    → Jump to matching bracket/parenthesis",
    "  {                    → Jump to previous paragraph",
    "  }                    → Jump to next paragraph",
    "  Ctrl+U               → Scroll up half page",
    "  Ctrl+D               → Scroll down half page",
    "  Ctrl+B               → Scroll up full page",
    "  Ctrl+F               → Scroll down full page",
    "  H                    → Jump to top of screen",
    "  M                    → Jump to middle of screen",
    "  L                    → Jump to bottom of screen",
    "  cs                   → Change Surround with Parenthesis and more (with vim-surround plugin)",
    "  <leader>xx           → Toggle diagnoistics numbers",
    "  select text → S(     → Surround selection with parentheses, brackets, quotes, etc. (with vim-surround plugin)",
    " ",
    "EDITING:",
    "  gc  (visual)         → Toggle comment on selection",
    "  gbc                  → Toggle block comment (line)",
    "  gb  (visual)         → Toggle block comment (selection)",
    "  gc{motion}           → Comment using motion (e.g. gc3j)",
    "  gcip                 → Comment inner paragraph",
    "  i                    → Insert mode before cursor",
    "  I                    → Insert at beginning of line",
    "  a                    → Insert mode after cursor",
    "  A                    → Insert at end of line",
    "  o                    → Open new line below",
    "  O                    → Open new line above",
    "  r                    → Replace single character",
    "  R                    → Replace mode",
    "  s                    → Substitute character",
    "  S                    → Substitute line",
    "  u                    → Undo",
    "  Ctrl+R               → Redo",
    "  .                    → Repeat last command",
    "  y                    → Yank (copy)",
    "  yy                   → Yank line",
    "  p                    → Paste after cursor",
    "  P                    → Paste before cursor",
    "  dd                   → Delete line",
    "  J                    → Join lines",
    " ",
    "VISUAL MODE:",
    "  v                    → Visual mode (character)",
    "  V                    → Visual mode (line)",
    "  Ctrl+V               → Visual block mode",
    "  gv                   → Reselect last visual selection",
    " ",
    "SEARCH & REPLACE:",
    "  /                    → Search forward",
    "  ?                    → Search backward",
    "  n                    → Next search result",
    "  N                    → Previous search result",
    "  *                    → Search word under cursor forward",
    "  #                    → Search word under cursor backward",
    "  :s/old/new/          → Replace in current line",
    "  :%s/old/new/g        → Replace in entire file",
    "  :%s/old/new/gc       → Replace with confirmation",
    " ",
    "BUFFERS & FILES:",
    "  :e filename          → Edit file",
    "  :w                   → Write (save) file",
    "  :q                   → Quit",
    "  :wq                  → Write and quit",
    "  :q!                  → Quit without saving",
    "  :bn                  → Next buffer",
    "  :bp                  → Previous buffer",
    "  :bd                  → Delete buffer",
    "  :ls                  → List buffers",
    " ",
    "WINDOWS:",
    "  Ctrl+W s             → Split horizontally",
    "  Ctrl+W v             → Split vertically",
    "  Ctrl+W h/j/k/l       → Navigate windows",
    "  Ctrl+W w             → Cycle windows",
    "  Ctrl+W c             → Close window",
    "  Ctrl+W o             → Close all other windows",
    "  Ctrl+W +/-           → Resize window height",
    "  Ctrl+W </>           → Resize window width",
    " ",
    "MARKS & JUMPS:",
    "  m{a-z}               → Set mark",
    "  '{a-z}               → Jump to mark",
    "  ''                   → Jump to last position",
    "  Ctrl+O               → Jump to older position",
    "  Ctrl+I               → Jump to newer position",
    " ",
    "MACROS:",
    "  q{a-z}               → Record macro",
    "  q                    → Stop recording",
    "  @{a-z}               → Play macro",
    "  @@                   → Repeat last macro",
    "    ...",
  }

  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, help_text)
  vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd!<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":bd!<CR>", { noremap = true, silent = true })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.bo.modifiable = false
end

vim.keymap.set("n", "<F1>", show_help, { desc = "Show Neovim help" })
-- 	vim.api.nvim_buf_set_lines(0, 0, -1, false, help_text)
-- 	vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd!<CR>", { noremap = true, silent = true })
-- 	vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":bd!<CR>", { noremap = true, silent = true })
-- 	vim.api.nvim_win_set_cursor(0, { 1, 0 })
-- 	vim.bo.modifiable = false
-- end

vim.keymap.set("n", "<F1>", show_help, { desc = "Show Neovim help" })

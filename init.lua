vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
local has_display = vim.env.DISPLAY and vim.env.DISPLAY ~= ""
local has_wayland = vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= ""

if is_wsl and executable("/mnt/c/Tools/win32yank.exe") then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "/mnt/c/Tools/win32yank.exe -i --crlf",
      ["*"] = "/mnt/c/Tools/win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "/mnt/c/Tools/win32yank.exe -o --lf",
      ["*"] = "/mnt/c/Tools/win32yank.exe -o --lf",
    },
    cache_enabled = 0,
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
		" ",
		"███╗   ██╗██╗   ██╗██╗███╗   ███╗",
		"████╗  ██║██║   ██║██║████╗ ████║",
		"██╔██╗ ██║██║   ██║██║██╔████╔██║",
		"██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
		"██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
		"╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
		" ",
		"KEYBINDINGS (Sorted):",
		" ",
		"Alt+B        → Toggle project browser (tree + telescope)",
		"Alt+E        → Toggle diagnostics",
		"Alt+F        → Multi-cursor replace",
		"Alt+H        → Horizontal split",
		"Alt+Home     → Open telescope",
		"Alt+Left     → Start of line",
		"Alt+Right    → End of line",
		"Alt+T        → Toggle terminal",
		"Alt+V        → Vertical split",
		" ",
		"Ctrl+A       → Select all",
		"Ctrl+C       → Copy all",
		"Ctrl+X       → Cut all",
		"Ctrl+Z       → Delete all (no yank)",
		" ",
		"Home         → Jump back to editor buffer",
		" ",
		"PageDown     → Jump to last empty line",
		"PageUp       → Jump to top of file",
		" ",
		"Shift+CF     → Find files in current folder",
		"Shift+E      → Toggle file explorer",
		"Shift+FG     → Grep text in project",
		"Shift+FF     → Find files in project",
		"Shift+FH     → Find files in HOME directory",
		"Shift+FS     → Find files in chosen folder",
		"Shift+PageDown → Next window",
		"Shift+PageUp   → Previous window",
		"Shift+S      → Save all and quit",
		"Shift+TS     → Grep text in chosen folder",
		"Shift+Z      → Quit all without saving",
		" ",
		"S            → Save all and quit",
		"Z            → Quit all without saving",
		" ",
	}

	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.api.nvim_buf_set_lines(0, 0, -1, false, help_text)
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	vim.bo.modifiable = false
end

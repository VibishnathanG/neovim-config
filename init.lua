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

local is_wsl = vim.fn.has("wsl") == 1

if is_wsl then
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
end

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
local keymaps = require("keymaps")
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

vim.keymap.set({ "n", "i", "v" }, "<F1>", function()
	vim.cmd("stopinsert")
	keymaps.show_help()
end, {
	noremap = true,
	silent = true,
	desc = "Show Neovim help",
})

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function(args)
-- 		local buf = args.buf

-- 		vim.schedule(function()
-- 			if not vim.api.nvim_buf_is_valid(buf) then
-- 				return
-- 			end

-- 			local name = vim.api.nvim_buf_get_name(buf)
-- 			local bo = vim.bo[buf]

-- 			if name == "" then
-- 				return
-- 			end

-- 			if bo.buftype ~= "" then
-- 				return
-- 			end

-- 			if not bo.modifiable then
-- 				return
-- 			end

-- 			if vim.api.nvim_get_mode().mode == "n" then
-- 				vim.cmd("startinsert")
-- 			end
-- 		end)
-- 	end,
-- })

local map = vim.keymap.set

---------------------------------------------------
-- HELP SYSTEM
---------------------------------------------------
local function show_help()
	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false

	local help_lines = {
		"╔════════════════════════════════════════════════════════════╗",
		"║         NEOVIM KEYBINDINGS REFERENCE - CUSTOM              ║",
		"╚════════════════════════════════════════════════════════════╝",
		" ",
		"FILE NAVIGATION:",
		"  Shift+E              → Toggle file explorer",
		"  Shift+FF             → Find files in project",
		"  Shift+FG             → Grep text in project",
		"  Shift+CF             → Find files in current folder",
		"  Shift+FH             → Find files in HOME directory",
		"  Shift+FS             → Find files in chosen folder",
		"  Shift+TS             → Grep text in chosen folder",
		"  Shift+Home           → Toggle file tree",
		"  Alt+Home             → Toggle telescope (search only)",
		" ",
		"EDITING & SELECTION:",
		"  Ctrl+A               → Select all",
		"  Ctrl+C               → Copy all",
		"  Ctrl+Shift+C         → Yank current line",
		"  Ctrl+X               → Cut all",
		"  Ctrl+Z               → Delete all (no yank)",
		"  Alt+F                → Replace everywhere",
		"  Ctrl+/               → Toggle comment (line)",
		"  Ctrl+Shift+/         → Toggle comment (block)",
		" ",
		"WINDOW MANAGEMENT:",
		"  Alt+V                → Vertical split",
		"  Alt+H                → Horizontal split",
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
		"  Ctrl+G               → Go to line number",
		" ",
		"FORMATTING:",
		"  Visual >             → Indent right (repeatable)",
		"  Visual <             → Indent left (repeatable)",
		"  Alt+=                → Auto-format selection",
		" ",
		"UTILITIES:",
		"  Shift+DT             → Toggle diagnostics",
		"  Alt+E                → Toggle error list",
		"  Ctrl+L               → Clear highlights",
		"  Ctrl+S               → Save current file",
		" ",
		"SESSION CONTROL:",
		"  Shift+Z              → Quit all without saving",
		"  Shift+S              → Save all and quit",
		" ",
		"DELETE (no clipboard):",
		"  d, D, x, c           → Delete without clipboard",
		" ",
		"F1                   → Show this help",
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
		"  0, $                 → Jump to line start/end",
		"  gg, G                → Jump to file start/end",
		"  {, }                 → Jump by paragraph",
		"  (, )                 → Jump by sentence",
		" ",
		"SEARCH & REPLACE:",
		"  /pattern             → Search forward",
		"  ?pattern             → Search backward",
		"  n, N                 → Next/previous search result",
		"  *, #                 → Search word under cursor",
		"  :s/old/new           → Replace in line",
		"  :%s/old/new/g        → Replace in file",
		" ",
		"EDITING:",
		"  i, a                 → Insert before/after cursor",
		"  I, A                 → Insert at line start/end",
		"  o, O                 → New line below/above",
		"  r                    → Replace single character",
		"  u, Ctrl+R            → Undo/Redo",
		"  .                    → Repeat last command",
		"  p, P                 → Paste after/before cursor",
		"  yy                   → Yank current line",
		"  dd                   → Delete current line",
		" ",
		"SELECTION (Visual Mode):",
		"  v                    → Start character selection",
		"  V                    → Start line selection",
		"  Ctrl+V               → Start block selection",
		"  ~                    → Toggle case",
		" ",
		"MARKS & REGISTERS:",
		"  m{a-z}               → Set mark",
		"  '{a-z}               → Jump to mark",
		"  :marks               → List all marks",
		"  :registers           → List all registers",
		" ",
		"WINDOWS:",
		"  Ctrl+W w             → Switch windows",
		"  Ctrl+W h/j/k/l       → Move to window",
		"  Ctrl+W H/J/K/L       → Rotate windows",
		"  Ctrl+W -/+           → Resize window",
		" ",
	}

	vim.api.nvim_buf_set_lines(0, 0, -1, false, help_lines)
	vim.api.nvim_buf_set_keymap(0, "n", "q", ":bdelete<CR>", { noremap = true, silent = true })
end

map("n", "<A-?>", show_help, { desc = "Show help" })

---------------------------------------------------
-- WELCOME SCREEN
---------------------------------------------------

local function show_welcome()
	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false

	local welcome_text = {
		"",
		"",
		"                    ___  _ __  _____      _(_) |_| |____   _(_) |__ (_)___| |__   ",
		"                   / _ \\| '_ \\/ __\\ \\ /\\ / / | __| '_ \\ \\ / / | '_ \\| / __| '_ \\  ",
		"                  | (_) | |_) \\__ \\\\ V  V /| | |_| | | \\ V /| | |_) | \\__ \\ | | | ",
		"                   \\___/| .__/|___/ \\_/\\_/ |_|\\__|_| |_|\\_/ |_|_.__/|_|___/_| |_| ",
		"                        |_|                                                        ",
		"",
		"",
		"                              ◆ Welcome to Your Editor ◆",
		"",
		"",
		"                                    Quick Start Guide",
		"",
		"                        o   →  Open an existing file",
		"                        n   →  Create a new file",
		"                        f   →  Open a folder",
		"                        s   →  Create scratch buffer",
		"                        ?   →  Show keybindings help (F1)",
		"                        q   →  Quit",
		"",
		"",
		"                    Press any key above to get started...",
		"",
	}

	vim.api.nvim_buf_set_lines(0, 0, -1, false, welcome_text)
	vim.api.nvim_win_set_cursor(0, { 1, 0 })

	local opts = { buffer = true, silent = true, noremap = true }

	map("n", "o", function()
		vim.cmd("enew")
		require("telescope.builtin").find_files({
			cwd = vim.fn.getcwd(),
			hidden = true,
			no_ignore = true,
		})
		vim.notify("📂 Telescope opened - Browse and select files", vim.log.levels.INFO)
	end, opts)

	map("n", "n", function()
		vim.ui.input({ prompt = "Enter new file name: " }, function(input)
			if input and input ~= "" then
				vim.cmd("enew")
				vim.cmd("write " .. input)
				vim.notify("✨ New file created: " .. input, vim.log.levels.INFO)
			end
		end)
	end, opts)

	map("n", "f", function()
		vim.ui.input({ prompt = "Enter folder path: ", default = vim.fn.getcwd() }, function(input)
			if input and input ~= "" then
				if vim.fn.isdirectory(input) == 1 then
					vim.cmd("cd " .. input)
					vim.cmd("enew")
					vim.notify("📁 Folder opened: " .. input, vim.log.levels.INFO)
				else
					vim.notify("❌ Not a valid directory", vim.log.levels.WARN)
				end
			end
		end)
	end, opts)

	map("n", "s", function()
		vim.cmd("enew")
		vim.bo.filetype = "scratch"
		vim.bo.buftype = ""
		vim.notify("📝 Scratch buffer created - changes won't be saved", vim.log.levels.INFO)
	end, opts)

	map("n", "?", show_help, opts)
	map("n", "q", "<cmd>qa!<CR>", opts)
end

---------------------------------------------------
-- FILE PATH DISPLAY IN STATUS LINE
---------------------------------------------------

vim.opt.statusline = "%f %m %h %w %y [%{&fileformat}] %p%% [%l:%c]"
-- Enhanced version with full path
map("n", "<leader>fp", function()
	local filepath = vim.fn.expand("%:p")
	vim.notify("📍 Full path: " .. filepath, vim.log.levels.INFO)
end, { desc = "Show full file path" })

---------------------------------------------------
-- COMMENT TOGGLE (using native Neovim)
---------------------------------------------------

local function toggle_comment()
	local line = vim.fn.getline(".")
	local stripped = vim.fn.trim(line)

	if vim.fn.match(stripped, "^--") == 0 then
		-- Uncomment
		local new_line = line:gsub("^(%s*)--", "%1", 1)
		vim.fn.setline(".", new_line)
		vim.notify("💬 Comment removed", vim.log.levels.INFO)
	else
		-- Comment
		local new_line = line:gsub("^(%s*)", "%1-- ", 1)
		vim.fn.setline(".", new_line)
		vim.notify("💬 Comment added", vim.log.levels.INFO)
	end
end

map("n", "<C-/>", toggle_comment, { silent = true })
map("v", "<C-/>", function()
	vim.cmd("'<,'>normal! " .. toggle_comment())
end, { silent = true })

---------------------------------------------------
-- Visual block fallback
---------------------------------------------------
map({ "n", "v" }, "<S-v>", "<C-v>")

---------------------------------------------------
-- FILE EXPLORER
---------------------------------------------------
map("n", "<S-e>", "<cmd>NvimTreeToggle<CR>")
map("n", "<S-Home>", "<cmd>NvimTreeToggle<CR>")

---------------------------------------------------
-- PROJECT SEARCH
---------------------------------------------------
map("n", "<S-f><S-f>", function()
	require("telescope.builtin").find_files()
	vim.notify("🔍 Searching files in project", vim.log.levels.INFO)
end)

map("n", "<S-f><S-g>", function()
	require("telescope.builtin").live_grep()
	vim.notify("🔎 Grep search active", vim.log.levels.INFO)
end)

map("n", "<S-c><S-f>", function()
	require("telescope.builtin").find_files({
		cwd = vim.fn.getcwd(),
		hidden = true,
		no_ignore = true,
	})
	vim.notify("📂 Searching in: " .. vim.fn.getcwd(), vim.log.levels.INFO)
end)

map("n", "<S-f><S-h>", function()
	require("telescope.builtin").find_files({
		cwd = vim.loop.os_homedir(),
		hidden = true,
		no_ignore = true,
	})
	vim.notify("🏠 Searching in HOME directory", vim.log.levels.INFO)
end)

map("n", "<S-f><S-s>", function()
	vim.ui.input({ prompt = "Search path: ", default = "/" }, function(input)
		if not input or input == "" then
			return
		end
		require("telescope.builtin").find_files({
			cwd = input,
			hidden = true,
			no_ignore = true,
			follow = true,
		})
		vim.notify("🔍 Searching in: " .. input, vim.log.levels.INFO)
	end)
end)

map("n", "<S-t><S-s>", function()
	vim.ui.input({ prompt = "Grep path: ", default = "/" }, function(input)
		if not input or input == "" then
			return
		end
		require("telescope.builtin").live_grep({
			cwd = input,
			additional_args = function()
				return { "--hidden", "--no-ignore" }
			end,
		})
		vim.notify("🔎 Grep in: " .. input, vim.log.levels.INFO)
	end)
end)

---------------------------------------------------
-- SPLIT VIEW
---------------------------------------------------
map("n", "<A-V>", function()
	vim.cmd("vsplit")
	vim.notify("➡️  Vertical split created", vim.log.levels.INFO)
end)

map("n", "<A-H>", function()
	vim.cmd("split")
	vim.notify("⬇️  Horizontal split created", vim.log.levels.INFO)
end)

-- Equal window sizes
map("n", "<C-w>=", function()
	vim.cmd("wincmd =")
	vim.notify("📐 Windows equalized", vim.log.levels.INFO)
end)

---------------------------------------------------
-- SELECT ALL / COPY / CUT / DELETE
---------------------------------------------------
map("n", "<C-a>", function()
	vim.cmd.normal({ "ggVG", bang = true })
end)

map("n", "<C-c>", function()
	vim.cmd.normal({ "ggVGy", bang = true })
	vim.notify("✅ All content copied", vim.log.levels.INFO)
end)

map("n", "<C-x>", function()
	vim.cmd.normal({ "ggVGd", bang = true })
	vim.notify("✂️  All content cut", vim.log.levels.INFO)
end)

map("n", "<C-z>", function()
	vim.cmd.normal({ 'ggVG"_d', bang = true })
end)

---------------------------------------------------
-- SAVE CURRENT FILE
---------------------------------------------------
map("n", "<C-s>", function()
	vim.cmd("write")
	vim.notify("💾 File saved: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end)

---------------------------------------------------
-- WINDOW ROTATION
---------------------------------------------------
map({ "n", "i" }, "<S-PageDown>", "<Esc><C-w>w0i")
map({ "n", "i" }, "<S-PageUp>", "<Esc><C-w>W0i")

---------------------------------------------------
-- PAGE UP / DOWN
---------------------------------------------------
local function ensure_insert()
	if vim.fn.mode() ~= "i" then
		vim.cmd("startinsert")
	end
end

map({ "n", "i" }, "<PageUp>", function()
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	ensure_insert()
end)

local function goto_last_empty_line()
	local last = vim.fn.line("$")
	local text = vim.fn.getline(last)
	if text ~= "" then
		vim.api.nvim_buf_set_lines(0, last, last, false, { "" })
		last = last + 1
	end
	vim.api.nvim_win_set_cursor(0, { last, 0 })
	ensure_insert()
end

map({ "n", "i" }, "<PageDown>", goto_last_empty_line)

---------------------------------------------------
-- GO TO LINE (Ctrl+G)
---------------------------------------------------
map("n", "<C-g>", function()
	vim.ui.input({ prompt = "Go to line: " }, function(input)
		if input and input ~= "" then
			local line_no = tonumber(input)
			if line_no then
				vim.api.nvim_win_set_cursor(0, { line_no, 0 })
				vim.notify("➡️  Jumped to line " .. line_no, vim.log.levels.INFO)
			end
		end
	end)
end)

---------------------------------------------------
-- JUMP TO FILE START/END
---------------------------------------------------
map("n", "<C-Home>", function()
	vim.cmd("normal! gg0")
	vim.notify("⬆️  Jumped to start of file", vim.log.levels.INFO)
end)

map("n", "<C-End>", function()
	vim.cmd("normal! G$")
	vim.notify("⬇️  Jumped to end of file", vim.log.levels.INFO)
end)

---------------------------------------------------
-- INDENT KEYS
---------------------------------------------------
map("v", ">", ">gv")
map("v", "<", "<gv")

---------------------------------------------------
-- AUTO FORMAT
---------------------------------------------------
map({ "n", "v" }, "<A-=>", function()
	vim.lsp.buf.format()
	vim.notify("✨ Code formatted", vim.log.levels.INFO)
end, { silent = true })

---------------------------------------------------
-- CLEAR HIGHLIGHTS
---------------------------------------------------
map("n", "<C-l>", function()
	vim.cmd("nohlsearch")
	vim.notify("🗑️  Highlights cleared", vim.log.levels.INFO)
end)

---------------------------------------------------
-- PERSISTENT UNDO
---------------------------------------------------
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

---------------------------------------------------
-- DIAGNOSTICS TOGGLE
---------------------------------------------------
local diagnostics_enabled = true

local function toggle_diagnostics()
	diagnostics_enabled = not diagnostics_enabled
	if diagnostics_enabled then
		vim.diagnostic.enable()
		vim.notify("🔍 Diagnostics ON", vim.log.levels.INFO)
	else
		vim.diagnostic.enable(false)
		vim.notify("🔗 Diagnostics OFF", vim.log.levels.INFO)
	end
end

map("n", "<S-d><S-t>", toggle_diagnostics)

---------------------------------------------------
-- ERROR LIST TOGGLE
---------------------------------------------------
map("n", "<A-e>", function()
	local enabled = vim.diagnostic.is_enabled()
	if enabled then
		vim.diagnostic.enable(false)
		vim.notify("❌ Errors hidden", vim.log.levels.INFO)
	else
		vim.diagnostic.enable()
		vim.notify("⚠️  Errors visible", vim.log.levels.INFO)
	end
end)

---------------------------------------------------
-- LINE NAVIGATION
---------------------------------------------------
local function smart_start_of_line()
	local mode = vim.fn.mode()
	vim.cmd("normal! 0")
	if mode == "i" then
		vim.cmd("startinsert")
	end
end

local function smart_end_of_line()
	local mode = vim.fn.mode()
	vim.cmd("normal! $")
	if mode == "i" then
		vim.cmd("startinsert")
	end
end

map({ "n", "i", "v" }, "<A-Left>", smart_start_of_line)
map({ "n", "i", "v" }, "<A-Right>", smart_end_of_line)

---------------------------------------------------
-- TELESCOPE TOGGLE
---------------------------------------------------
local telescope_win = nil

map("n", "<A-Home>", function()
	if telescope_win and vim.api.nvim_win_is_valid(telescope_win) then
		pcall(function()
			vim.api.nvim_win_close(telescope_win, true)
		end)
		telescope_win = nil
		vim.notify("🔲 Telescope closed", vim.log.levels.INFO)
	else
		require("telescope.builtin").find_files({
			cwd = vim.fn.getcwd(),
			hidden = true,
			no_ignore = true,
			attach_mappings = function(prompt_bufnr, map)
				telescope_win = vim.api.nvim_get_current_win()
				return true
			end,
		})
		vim.notify("🔲 Telescope opened", vim.log.levels.INFO)
	end
end)

---------------------------------------------------
-- STARTUP ROUTING
---------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local args = vim.fn.argv()

		if #args == 0 then
			show_welcome()
			return
		end

		local target = args[1]

		if vim.fn.isdirectory(target) == 1 then
			vim.cmd("cd " .. target)
			require("telescope.builtin").find_files({
				cwd = target,
				hidden = true,
				no_ignore = true,
			})
			vim.notify("📁 Opened folder: " .. target, vim.log.levels.INFO)
			return
		end
	end,
	once = true,
})

---------------------------------------------------
-- ALWAYS FOLLOW BUFFER DIRECTORY
---------------------------------------------------
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local file = vim.fn.expand("%:p:h")
		if file ~= "" then
			vim.cmd("cd " .. file)
		end
	end,
})

---------------------------------------------------
-- JUMP BACK TO EDITOR
---------------------------------------------------
map("n", "<Home>", function()
	pcall(function()
		vim.cmd("wincmd p")
	end)
	vim.notify("📝 Switched to editor", vim.log.levels.INFO)
end)

---------------------------------------------------
-- TERMINAL TOGGLE
---------------------------------------------------
local term_win = nil

local function toggle_terminal()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		local buf = vim.api.nvim_win_get_buf(term_win)
		vim.api.nvim_win_close(term_win, true)
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
		term_win = nil
		vim.notify("🔲 Terminal closed", vim.log.levels.INFO)
		return
	end

	vim.cmd("topleft split")
	vim.cmd("resize 12")
	vim.cmd("terminal")
	term_win = vim.api.nvim_get_current_win()
	vim.cmd("startinsert")
	vim.notify("🖥️  Terminal opened", vim.log.levels.INFO)
end

map({ "n", "i" }, "<A-t>", toggle_terminal)

---------------------------------------------------
-- CLIPBOARD SAFE DELETE
---------------------------------------------------
map({ "n", "v" }, "d", '"_d')
map({ "n", "v" }, "D", '"_D')
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "c", '"_c')

---------------------------------------------------
-- YANK CURRENT LINE
---------------------------------------------------
map({ "n", "i" }, "<C-S-c>", function()
	vim.cmd("normal! yy")
	vim.notify("📋 Line copied: " .. vim.fn.getline("."), vim.log.levels.INFO)
end, { silent = true })

map("v", "<C-S-c>", '"*y', { silent = true })

---------------------------------------------------
-- REPLACE EVERYWHERE
---------------------------------------------------
local function replace_everywhere()
	local mode = vim.fn.mode()
	local text

	if mode:match("[vV\22]") then
		local _, ls, cs = unpack(vim.fn.getpos("'<"))
		local _, le, ce = unpack(vim.fn.getpos("'>"))
		local lines = vim.fn.getline(ls, le)

		if #lines == 0 then
			return
		end

		lines[#lines] = string.sub(lines[#lines], 1, ce)
		lines[1] = string.sub(lines[1], cs)

		text = table.concat(lines, "\n")
	else
		text = vim.fn.expand("<cword>")
	end

	if text == "" then
		return
	end

	local replacement = vim.fn.input("Replace with: ")
	if replacement == "" then
		return
	end

	local escaped = vim.fn.escape(text, [[\/.*$^~[]])
	local repl = vim.fn.escape(replacement, [[\/&]])

	local buf = table.concat(vim.fn.getline(1, "$"), "\n")
	local _, count = string.gsub(buf, escaped, "")

	vim.cmd(string.format("%%s/%s/%s/g", escaped, repl))
	vim.notify("🔄 Replaced " .. count .. " occurrence(s)", vim.log.levels.INFO)
end

map({ "n", "v", "x", "i" }, "<A-f>", replace_everywhere, { silent = true })

---------------------------------------------------
-- DIAGNOSTICS DEFAULT STATE
---------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		vim.diagnostic.enable(false)
	end,
})

---------------------------------------------------
-- UI SETTINGS
---------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

---------------------------------------------------
-- SHOW FILE PATH IN CMDLINE
---------------------------------------------------
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local filepath = vim.fn.expand("%:p")
		if filepath and filepath ~= "" then
			vim.opt.statusline = "%f %m %h %w [%Y] %p%% [%l:%c]"
		end
	end,
})

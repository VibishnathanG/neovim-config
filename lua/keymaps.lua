local map = vim.keymap.set

-- Helper to safely feed keys when necessary
local function _feedkeys(raw)
	local keys = vim.api.nvim_replace_termcodes(raw, true, false, true)
	vim.api.nvim_feedkeys(keys, "m", true)
end

---------------------------------------------------
-- SESSION SHORTCUTS: Save / Quit behavior
-- Shift+Z : Quit all immediately without saving (force quit)
-- Shift+S : Save all and exit (write all then quit)
---------------------------------------------------
local function force_quit_all()
	pcall(function()
		vim.cmd("stopinsert")
	end)
	vim.cmd("qa!")
end

local function save_all_and_quit()
	pcall(function()
		vim.cmd("wa")
	end)
	vim.cmd("qa")
end

map({ "n", "v", "i" }, "<S-Z>", function()
	force_quit_all()
end, { silent = true, desc = "Force quit all (no save)" })
map({ "n", "v", "i" }, "<S-S>", function()
	save_all_and_quit()
end, { silent = true, desc = "Save all and quit" })

---------------------------------------------------
-- Yank / Cut current line to system clipboard (Ctrl+Shift+C / Ctrl+Shift+X)
---------------------------------------------------
map({ "n", "i", "v" }, "<A-S-c>", function()
	local line = vim.fn.getline(".")
	vim.fn.setreg("+", line .. "\n")
	if vim.fn.mode() == "i" then
		pcall(function()
			vim.cmd("stopinsert")
		end)
		vim.notify("📋 Line yanked to system clipboard — Insert exited briefly.", vim.log.levels.INFO)
		pcall(function()
			vim.cmd("startinsert")
		end)
	else
		vim.notify("📋 Line yanked to system clipboard. Preview: " .. line, vim.log.levels.INFO)
	end
end, { silent = true })

map({ "n", "i", "v" }, "<C-S-x>", function()
	local line = vim.fn.getline(".")
	vim.fn.setreg("+", line .. "\n")
	if vim.fn.mode() == "i" then
		pcall(function()
			vim.cmd("stopinsert")
		end)
		vim.cmd("normal! dd")
		vim.notify("✂️ Current line cut to system clipboard — Insert exited briefly.", vim.log.levels.INFO)
		pcall(function()
			vim.cmd("startinsert")
		end)
	else
		vim.cmd("normal! dd")
		vim.notify("✂️ Current line cut to system clipboard. Preview: " .. line, vim.log.levels.INFO)
	end
end, { silent = true })

---------------------------------------------------
-- HELP SYSTEM
---------------------------------------------------
local function show_help()
	vim.cmd("enew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false

	local help_lines =
	{
		"╔════════════════════════════════════════════════════════════╗",
		"║      NEOVIM KEYBINDINGS REFERENCE - CUSTOM (Quick)        ║",
		"║        NEOVIM KEYBINDINGS REFERENCE - CUSTOM (Quick)       ║",
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

	vim.api.nvim_buf_set_lines(0, 0, -1, false, help_lines)
	vim.api.nvim_buf_set_keymap(0, "n", "q", ":bdelete<CR>", { noremap = true, silent = true })
	vim.notify("📘 Help opened — Press 'q' to close (buffer-only, no file written).", vim.log.levels.INFO)
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
		"                           ╭──────────────────────────────────────────────────────────╮",
		"                           │                                                          │",
		"                           │    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗    │",
		"                           │    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║    │",
		"                           │    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    │",
		"                           │    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    │",
		"                           │    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║    │",
		"                           │    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝    │",
		"                           │                                                          │",
		"                           ╰──────────────────────────────────────────────────────────╯",
		"",
		"        ╭───────────────────────────────────────────────────────────────────────────────────────────────────╮",
		"        │                                                                                                   │",
		"        │   ██████╗ ██████╗ ███████╗██╗    ██╗██╗████████╗██╗  ██╗██╗   ██╗██╗██████╗ ██╗███████╗██╗  ██╗   │",
		"        │  ██╔═══██╗██╔══██╗██╔════╝██║    ██║██║╚══██╔══╝██║  ██║██║   ██║██║██╔══██╗██║██╔════╝██║  ██║   │",
		"        │  ██║   ██║██████╔╝███████╗██║ █╗ ██║██║   ██║   ███████║██║   ██║██║██████╔╝██║███████╗███████║   │",
		"        │  ██║   ██║██╔═══╝ ╚════██║██║███╗██║██║   ██║   ██╔══██║╚██╗ ██╔╝██║██╔══██╗██║╚════██║██╔══██║   │",
		"        │  ╚██████╔╝██║     ███████║╚███╔███╔╝██║   ██║   ██║  ██║ ╚████╔╝ ██║██████╔╝██║███████║██║  ██║   │",
		"        │   ╚═════╝ ╚═╝     ╚══════╝ ╚══╝╚══╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝   │",
		"        │                                                                                                   │",
		"        ╰───────────────────────────────────────────────────────────────────────────────────────────────────╯",
		"",
		"                                               ✨ ─── ⋆⋅☆⋅⋆ ─── ✨",
		"",
		"              ╭──────────────────────────────────────────────────────────────────────────────────╮",
		"              │                                                                                  │",
		"              │                          🎯 ✦ QUICK START MENU ✦ 🎯                              │",
		"              │                                                                                  │",
		"              ├──────────────────────────────────────────────────────────────────────────────────┤",
		"              │                                                                                  │",
		"              │    📂   Press 'o'   ➤   Open File Browser                                        │",
		"              │    📄   Press 'n'   ➤   Create New File                                          │",
		"              │    📁   Press 'f'   ➤   Open Folder                                              │",
		"              │    📝   Press 's'   ➤   Create Scratch Buffer                                    │",
		"              │    ❓   Press '?'   ➤   Show Help & Keybindings                                  │",
		"              │    🚪   Press 'q'   ➤   Quit Neovim                                              │",
		"              │                                                                                  │",
		"              ├──────────────────────────────────────────────────────────────────────────────────┤",
		"              │                                                                                  │",
		"              │                      🌟 Ready to code? Choose an option! 🌟                      │",
		"              │                                                                                  │",
		"              ╰──────────────────────────────────────────────────────────────────────────────────╯",
		"",
		"                                             ⋆｡‧˚ʚ♡ɞ˚‧｡⋆ ─── ⋆｡‧˚ʚ♡ɞ˚‧｡⋆",
		"",
	}

	vim.api.nvim_buf_set_lines(0, 0, -1, false, welcome_text)
	vim.api.nvim_win_set_cursor(0, { 1, 0 })

	local opts = { buffer = true, silent = true, noremap = true }

	map("n", "o", function()
		require("telescope.builtin").find_files({ cwd = vim.fn.getcwd(), hidden = true, no_ignore = true })
		vim.notify(
			"📂 Telescope opened — Browse and select files (normal mode).\nTarget cwd: " .. vim.fn.getcwd(),
			vim.log.levels.INFO
		)
	end, opts)

	map("n", "n", function()
		vim.ui.input({ prompt = "Enter new file name: " }, function(input)
			if input and input ~= "" then
				vim.cmd("enew")
				vim.cmd("write " .. input)
				vim.notify("✨ New file created: " .. input .. " — Buffer written to disk.", vim.log.levels.INFO)
			else
				vim.notify("⚠️ New file creation cancelled or empty name provided.", vim.log.levels.WARN)
			end
		end)
	end, opts)

	map("n", "f", function()
		vim.ui.input({ prompt = "Enter folder path: ", default = vim.fn.getcwd() }, function(input)
			if input and input ~= "" then
				if vim.fn.isdirectory(input) == 1 then
					vim.cmd("cd " .. input)
					vim.cmd("enew")
					vim.notify(
						"📁 Folder opened: " .. input .. " — Current working directory changed.",
						vim.log.levels.INFO
					)
				else
					vim.notify("❌ Not a valid directory: " .. tostring(input), vim.log.levels.WARN)
				end
			else
				vim.notify("⚠️ Folder open cancelled.", vim.log.levels.WARN)
			end
		end)
	end, opts)

	map("n", "s", function()
		vim.cmd("enew")
		vim.bo.filetype = "scratch"
		vim.bo.buftype = ""
		vim.notify("📝 Scratch buffer created — Changes are not auto-saved.", vim.log.levels.INFO)
	end, opts)

	map("n", "?", show_help, opts)
	map("n", "q", "<cmd>qa!<CR>", opts)
end

---------------------------------------------------
-- FILE PATH DISPLAY IN STATUS LINE
---------------------------------------------------
vim.opt.statusline = "%f %m %h %w %y [%{&fileformat}] %p%% [%l:%c]"
map("n", "<leader>fp", function()
	local filepath = vim.fn.expand("%:p")
	vim.notify("📍 Full path: " .. filepath .. " — Scope: active buffer (normal mode).", vim.log.levels.INFO)
end, { desc = "Show full file path" })

---------------------------------------------------
-- Commenting helpers: filetype-aware
---------------------------------------------------
local function get_comment_tokens()
	local ft = vim.bo.filetype
	local mapping = {
		lua = { line = "--", block = { "--[[", "]]" } },
		python = { line = "#", block = { "'''", "'''" } },
		sh = { line = "#" },
		bash = { line = "#" },
		zsh = { line = "#" },
		yaml = { line = "#" },
		yml = { line = "#" },
		json = { line = "//" },
		javascript = { line = "//", block = { "/*", "*/" } },
		typescript = { line = "//", block = { "/*", "*/" } },
		html = { block = { "<!--", "-->" } },
		css = { block = { "/*", "*/" } },
	}
	return mapping[ft] or { line = "--" }
end

local function toggle_comment_ft_line()
	local tokens = get_comment_tokens()
	local line = vim.fn.getline(".")
	local trimmed = vim.fn.trim(line)
	if tokens.line then
		local pat = vim.pesc(tokens.line)
		if vim.regex("^\\s*" .. pat):match_str(trimmed) then
			local new_line = line:gsub("^(%s*)" .. pat .. "%s*", "%1", 1)
			vim.fn.setline(".", new_line)
			vim.notify("💬 Line uncommented (" .. vim.bo.filetype .. ")", vim.log.levels.INFO)
		else
			local new_line = line:gsub("^(%s*)", "%1" .. tokens.line .. " ", 1)
			vim.fn.setline(".", new_line)
			vim.notify("💬 Line commented (" .. vim.bo.filetype .. ")", vim.log.levels.INFO)
		end
	elseif tokens.block then
		local s, e = tokens.block[1], tokens.block[2]
		vim.fn.setline(".", s .. " " .. line .. " " .. e)
		vim.notify("💬 Wrapped line in block comment (" .. vim.bo.filetype .. ")", vim.log.levels.INFO)
	end
end

map({ "n", "i" }, "<C-S-L>", function()
	local was_insert = (vim.fn.mode() == "i")
	if was_insert then
		pcall(function()
			vim.cmd("stopinsert")
		end)
	end
	toggle_comment_ft_line()
	if was_insert then
		pcall(function()
			vim.cmd("startinsert")
		end)
	end
end, { silent = true, desc = "Toggle comment (filetype-aware)" })

map("n", "<C-/>", function()
	toggle_comment_ft_line()
end, { silent = true })
map("v", "<C-/>", function()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	for l = start_line, end_line do
		vim.api.nvim_win_set_cursor(0, { l, 0 })
		toggle_comment_ft_line()
	end
	vim.notify("💬 Toggled comments across selection (" .. vim.bo.filetype .. ")", vim.log.levels.INFO)
end, { silent = true })

---------------------------------------------------
-- Visual block fallback
---------------------------------------------------
map({ "n", "v" }, "<S-v>", "<C-v>")

---------------------------------------------------
-- FILE EXPLORER
---------------------------------------------------
map("n", "<S-e>", function()
	vim.cmd("NvimTreeToggle")
	vim.notify(
		" File Explorer toggled — Action: NvimTreeToggle (normal).\nTarget: "
			.. (vim.fn.expand("%:p") or "[no-file]"),
		vim.log.levels.INFO
	)
end)

map("n", "<S-Home>", function()
	vim.cmd("NvimTreeToggle")
	vim.notify(
		" File Explorer toggled — Action: NvimTreeToggle (normal).\nTriggered via Shift+Home.",
		vim.log.levels.INFO
	)
end)

---------------------------------------------------
-- PROJECT SEARCH (Telescope)
---------------------------------------------------
map("n", "<S-f><S-f>", function()
	require("telescope.builtin").find_files()
	vim.notify("🔍 Project file search opened (Telescope). Mode: normal. Scope: entire project.", vim.log.levels.INFO)
end)

map("n", "<S-f><S-g>", function()
	require("telescope.builtin").live_grep()
	vim.notify("🔎 Live grep started (Telescope). Mode: normal. Scope: entire project.", vim.log.levels.INFO)
end)

map("n", "<S-c><S-f>", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.getcwd(), hidden = true, no_ignore = true })
	vim.notify("📂 Searching in cwd: " .. vim.fn.getcwd() .. " (Telescope).", vim.log.levels.INFO)
end)

map("n", "<S-f><S-h>", function()
	require("telescope.builtin").find_files({ cwd = vim.loop.os_homedir(), hidden = true, no_ignore = true })
	vim.notify("🏠 Searching in HOME directory (Telescope).", vim.log.levels.INFO)
end)

map("n", "<S-f><S-s>", function()
	vim.ui.input({ prompt = "Search path: ", default = "/" }, function(input)
		if not input or input == "" then
			vim.notify("⚠️ Search cancelled or empty path.", vim.log.levels.WARN)
			return
		end
		require("telescope.builtin").find_files({ cwd = input, hidden = true, no_ignore = true, follow = true })
		vim.notify("🔍 Searching in: " .. input .. " (Telescope).", vim.log.levels.INFO)
	end)
end)

map("n", "<S-t><S-s>", function()
	vim.ui.input({ prompt = "Grep path: ", default = "/" }, function(input)
		if not input or input == "" then
			vim.notify("⚠️ Grep cancelled or empty path.", vim.log.levels.WARN)
			return
		end
		require("telescope.builtin").live_grep({
			cwd = input,
			additional_args = function()
				return { "--hidden", "--no-ignore" }
			end,
		})
		vim.notify("🔎 Grep in: " .. input .. " (Telescope).", vim.log.levels.INFO)
	end)
end)

---------------------------------------------------
-- SPLIT VIEW
---------------------------------------------------
map("n", "<A-V>", function()
	vim.cmd("vsplit")
	vim.notify(
		"➡️  Vertical split created — Scope: window. Mode: normal. Safe: no buffer changed.",
		vim.log.levels.INFO
	)
end)

map("n", "<A-H>", function()
	vim.cmd("split")
	vim.notify("⬇️  Horizontal split created — Scope: window. Mode: normal.", vim.log.levels.INFO)
end)

map("n", "<C-w>=", function()
	vim.cmd("wincmd =")
	vim.notify("📐 Windows equalized — All visible windows resized equally.", vim.log.levels.INFO)
end)

---------------------------------------------------
-- SELECT ALL / COPY / CUT / DELETE
---------------------------------------------------
map("n", "<C-a>", function()
	vim.cmd.normal({ "ggVG", bang = true })
	vim.notify("🔎 Select all — Visual selection created (normal).", vim.log.levels.INFO)
end)
map("n", "<C-c>", function()
	vim.cmd.normal({ "ggVGy", bang = true })
	vim.notify("✅ All content copied to default register (yank). — Undo safe.", vim.log.levels.INFO)
end)
map("n", "<C-x>", function()
	vim.cmd.normal({ "ggVGd", bang = true })
	vim.notify(
		"✂️  All content cut (deleted) — Check undo if needed. Clipboard unaffected (uses default register).",
		vim.log.levels.INFO
	)
end)
map("n", "<C-z>", function()
	vim.cmd.normal({ 'ggVG"_d', bang = true })
	vim.notify("🗑️  All content deleted without affecting registers (blackhole).", vim.log.levels.INFO)
end)

---------------------------------------------------
-- SAVE CURRENT FILE
---------------------------------------------------
map("n", "<C-s>", function()
	vim.cmd("write")
	vim.notify("💾 File saved: " .. vim.fn.expand("%:t") .. " — Disk write completed.", vim.log.levels.INFO)
end)

---------------------------------------------------
-- WINDOW ROTATION
---------------------------------------------------
map({ "n", "i" }, "<S-PageDown>", function()
	_feedkeys("<Esc><C-w>w0i")
	vim.notify(
		"↪️ Window cycle: moved to next window and returned to insert (if previously in insert).",
		vim.log.levels.INFO
	)
end)
map({ "n", "i" }, "<S-PageUp>", function()
	_feedkeys("<Esc><C-w>W0i")
	vim.notify(
		"↩️ Window rotate: moved to previous window and returned to insert (if previously in insert).",
		vim.log.levels.INFO
	)
end)

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
	vim.notify(
		"⬆️ Jumped to top of file — Cursor moved, returned to insert mode if applicable.",
		vim.log.levels.INFO
	)
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
-- GO TO LINE (Ctrl+G) across modes
---------------------------------------------------
local function go_to_line_prompt()
	vim.ui.input({ prompt = "Go to line: " }, function(input)
		if input and input ~= "" then
			local line_no = tonumber(input)
			if line_no then
				vim.api.nvim_win_set_cursor(0, { line_no, 0 })
				vim.notify("➡️  Jumped to line " .. line_no .. " — Mode-aware.", vim.log.levels.INFO)
			else
				vim.notify("⚠️ Invalid line number provided.", vim.log.levels.WARN)
			end
		end
	end)
end
map({ "n", "i", "v" }, "<C-g>", function()
	if vim.fn.mode() == "i" then
		pcall(function()
			vim.cmd("stopinsert")
		end)
	end
	go_to_line_prompt()
end, { silent = true, desc = "Go to line (mode-aware)" })

---------------------------------------------------
-- JUMP TO FILE START/END
---------------------------------------------------
map("n", "<C-Home>", function()
	vim.cmd("normal! gg0")
	vim.notify("⬆️  Jumped to start of file — Mode: normal.", vim.log.levels.INFO)
end)
map("n", "<C-End>", function()
	vim.cmd("normal! G$")
	vim.notify("⬇️  Jumped to end of file — Mode: normal.", vim.log.levels.INFO)
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
	vim.notify("✨ Code formatted via LSP — Format request sent (mode-aware).", vim.log.levels.INFO)
end, { silent = true })

---------------------------------------------------
-- CLEAR HIGHLIGHTS
---------------------------------------------------
map("n", "<C-l>", function()
	vim.cmd("nohlsearch")
	vim.notify("🗑️  Highlights cleared — Search highlights removed.", vim.log.levels.INFO)
end)

---------------------------------------------------
-- PERSISTENT UNDO
---------------------------------------------------
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

---------------------------------------------------
-- DIAGNOSTICS: default ON, toggles and list
---------------------------------------------------
local diagnostics_enabled = true
vim.diagnostic.enable()
local function toggle_diagnostics()
	diagnostics_enabled = not diagnostics_enabled
	if diagnostics_enabled then
		vim.diagnostic.enable()
		vim.notify("🔍 Diagnostics ON — LSP diagnostics enabled globally.", vim.log.levels.INFO)
	else
		vim.diagnostic.enable(false)
		vim.notify("🔗 Diagnostics OFF — LSP diagnostics suppressed globally.", vim.log.levels.WARN)
	end
end
map("n", "<S-d><S-t>", toggle_diagnostics, { desc = "Toggle diagnostics (Shift+D T)" })
map("n", "<A-e>", function()
	local enabled = vim.diagnostic.is_enabled()
	if enabled then
		vim.diagnostic.enable(false)
		vim.notify("❌ Errors hidden — Diagnostic display disabled.", vim.log.levels.INFO)
	else
		vim.diagnostic.enable()
		vim.notify("⚠️  Errors visible — Diagnostic display enabled.", vim.log.levels.INFO)
	end
end)
local function show_diagnostics_loclist()
	vim.diagnostic.setloclist({ open = true })
	vim.notify("📋 Diagnostics list opened in location list.", vim.log.levels.INFO)
end
map("n", "<S-d><S-l>", show_diagnostics_loclist, { desc = "Open diagnostics location list" })

-- Keep diagnostics enabled on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		vim.diagnostic.enable()
	end,
})

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
		vim.notify("🔲 Telescope closed — Window closed (toggle).", vim.log.levels.INFO)
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
		vim.notify("🔲 Telescope opened — File search (toggle).", vim.log.levels.INFO)
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
			require("telescope.builtin").find_files({ cwd = target, hidden = true, no_ignore = true })
			vim.notify("📁 Opened folder: " .. target .. " — Autostart behavior.", vim.log.levels.INFO)
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
	vim.notify("📝 Switched to editor — Jumped back to previous window (normal).", vim.log.levels.INFO)
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
		vim.notify("🔲 Terminal closed — Buffer and window removed.", vim.log.levels.INFO)
		return
	end
	vim.cmd("topleft split")
	vim.cmd("resize 12")
	vim.cmd("terminal")
	term_win = vim.api.nvim_get_current_win()
	vim.cmd("startinsert")
	vim.notify("🖥️  Terminal opened — Insert mode enabled in terminal.", vim.log.levels.INFO)
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
-- YANK CURRENT LINE (fallback)
---------------------------------------------------
map({ "n", "i" }, "<C-S-c>", function()
	vim.cmd("normal! yy")
	vim.notify(
		"📋 Line copied — Content stored in default register.\nPreview: " .. vim.fn.getline("."),
		vim.log.levels.INFO
	)
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
	vim.notify(
		"🔄 Replaced "
			.. count
			.. " occurrence(s) — Scope: current buffer.\nOriginal: '"
			.. text
			.. "' → New: '"
			.. replacement
			.. "'",
		vim.log.levels.INFO
	)
end
map({ "n", "v", "x", "i" }, "<A-f>", replace_everywhere, { silent = true })

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

-- End of keymaps.lua

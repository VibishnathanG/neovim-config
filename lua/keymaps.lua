---------------------------------------------------
-- KEYMAP LEGEND
---------------------------------------------------
-- Shift+V      → Visual block mode
-- Shift+E      → Toggle file explorer
-- Shift+FF     → Find files in project
-- Shift+FG     → Grep text in project
-- Shift+CF     → Find files in current folder
-- Shift+FH     → Find files in HOME directory
-- Shift+FS     → Find files in chosen folder
-- Shift+TS     → Grep text in chosen folder
--
-- Alt+V        → Vertical split
-- Alt+H        → Horizontal split
--
-- Ctrl+A       → Select all
-- Ctrl+C       → Copy all
-- Ctrl+X       → Cut all
-- Ctrl+Z       → Delete all (no yank)
--
-- Shift+Z      → Quit all without saving
-- Shift+S      → Save all and quit
--
-- PageUp       → Jump to top of file and insert
-- PageDown     → Jump to last empty line and insert
--
-- Shift+PgDn   → Rotate to next window
-- Shift+PgUp   → Rotate to previous window
--
-- Visual >     → Indent right (repeatable)
-- Visual <     → Indent left (repeatable)
---------------------------------------------------


local map = vim.keymap.set

-- Visual block fallback (terminal-safe)
map({ "n", "v" }, "<S-v>", "<C-v>")

-- File explorer
map("n", "<S-e>", "<cmd>NvimTreeToggle<CR>")

-- Project search
map("n", "<S-f><S-f>", "<cmd>Telescope find_files<CR>")
map("n", "<S-f><S-g>", "<cmd>Telescope live_grep<CR>")

-- Current folder search
map("n", "<S-c><S-f>", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.getcwd(),
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Find files in current folder" })

-- HOME directory search
map("n", "<S-f><S-h>", function()
  require("telescope.builtin").find_files({
    cwd = vim.loop.os_homedir(),
    hidden = true,
    no_ignore = true,
  })
end)

-- Dynamic folder file search
map("n", "<S-f><S-s>", function()
  vim.ui.input({ prompt = "Search path: ", default = "/" }, function(input)
    if not input or input == "" then return end
    require("telescope.builtin").find_files({
      cwd = input,
      hidden = true,
      no_ignore = true,
      follow = true,
    })
  end)
end)

-- Dynamic folder text search
map("n", "<S-t><S-s>", function()
  vim.ui.input({ prompt = "Grep path: ", default = "/" }, function(input)
    if not input or input == "" then return end
    require("telescope.builtin").live_grep({
      cwd = input,
      additional_args = function()
        return { "--hidden", "--no-ignore" }
      end,
    })
  end)
end)

---------------------------------------------------
-- SPLIT VIEW (unchanged Alt bindings)
---------------------------------------------------

-- Vertical split
map("n", "<A-V>", "<cmd>vsplit<CR>")

-- Horizontal split
map("n", "<A-H>", "<cmd>split<CR>")

---------------------------------------------------
-- SELECT ALL / COPY / CUT / DELETE
---------------------------------------------------

-- Select all
map("n", "<C-a>", "ggVG")

-- Copy all
map("n", "<C-c>", "ggVGy")

-- Cut all
map("n", "<C-x>", "ggVGd")

-- Delete all (no yank)
map("n", "<C-z>", "ggVG\"_d")

-- Quit ALL without saving
vim.keymap.set("n", "Z", ":qa!<CR>")

-- Save ALL and quit
vim.keymap.set("n", "S", ":wqa<CR>")

---------------------------------------------------
-- WINDOW ROTATION (stable cursor reset)
---------------------------------------------------

-- Next window → go to column 0 → insert
vim.keymap.set({ "n", "i" }, "<S-PageDown>", "<Esc><C-w>w0i")

-- Previous window → go to column 0 → insert
vim.keymap.set({ "n", "i" }, "<S-PageUp>", "<Esc><C-w>W0i")

---------------------------------------------------
-- PAGE UP / DOWN → smart insert behavior
---------------------------------------------------

local function ensure_insert()
  if vim.fn.mode() ~= "i" then
    vim.cmd("startinsert")
  end
end

-- PageUp → top of file
vim.keymap.set({ "n", "i" }, "<PageUp>", function()
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  ensure_insert()
end)

-- PageDown → ensure empty last line
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

vim.keymap.set({ "n", "i" }, "<PageDown>", goto_last_empty_line)

---------------------------------------------------
-- BETTER INDENT KEYS
---------------------------------------------------

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")


---------------------------------------------------
-- PERSISTENT UNDO
---------------------------------------------------

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- If needed delete this file:
-- ~/.local/share/nvim/undo/

---------------------------------------------------

-- vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
--   callback = function()
--     if vim.v.exiting == vim.NIL then
--       vim.cmd("silent! wall")
--     end
--   end,
-- })

---------------------------------------------------

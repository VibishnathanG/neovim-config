-- Shift+V → Visual block mode
-- Shift+E → Toggle file explorer
-- Shift+FF → Find files in project
-- Shift+FG → Grep text in project
-- Shift+CF → Find files in current folder
-- Shift+FH → Find files in HOME directory
-- Shift+FS → Find files in chosen folder
-- Shift+TS → Grep text in chosen folder
-- Alt+V → Vertical split
-- Alt+H → Horizontal split
-- Ctrl+A → Select all
-- Ctrl+C → Copy all
-- Ctrl+X → Cut all
-- Ctrl+Z → Delete all (no yank)
-- Shift+Z → Quit all without saving
-- Shift+S → Save all and quit
-- PageUp → Jump to top of file and insert
-- PageDown → Jump to last empty line and insert
-- Shift+Home → Switch window/buffer
-- Alt+Left → Start of line
-- Alt+Right → End of line
-- Visual > → Indent right (repeatable)
-- Visual < → Indent left (repeatable)
-- Shift+DT → Toggle diagnostics
-- Alt+B → Toggle project browser (tree + telescope)
-- Home → Jump back to editor buffer
-- Alt+T → Toggle terminal split



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
-- DIAGNOSTICS TOGGLE (Shift + D T)
---------------------------------------------------

local diagnostics_enabled = true

local function toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled

  if diagnostics_enabled then
    vim.diagnostic.enable()
    print("Diagnostics ON")
  else
    vim.diagnostic.disable()
    print("Diagnostics OFF")
  end
end

vim.keymap.set("n", "<S-d><S-t>", toggle_diagnostics)



---------------------------------------------------
-- PROJECT LAUNCHER SYSTEM
---------------------------------------------------

local function open_project_ui()
  -- open tree
  require("nvim-tree.api").tree.open()

  -- open telescope and KEEP focus there
  require("telescope.builtin").find_files({
    cwd = vim.fn.getcwd(),
    hidden = true,
    no_ignore = true,
  })
end


---------------------------------------------------
-- ALT + ARROWS → line boundaries (all modes)
---------------------------------------------------

local function smart_start_of_line()
  local mode = vim.fn.mode()
  vim.cmd("normal! 0")
  if mode == "i" then vim.cmd("startinsert") end
end

local function smart_end_of_line()
  local mode = vim.fn.mode()
  vim.cmd("normal! $")
  if mode == "i" then vim.cmd("startinsert") end
end

vim.keymap.set({ "n", "i", "v" }, "<A-Left>", smart_start_of_line)
vim.keymap.set({ "n", "i", "v" }, "<A-Right>", smart_end_of_line)


---------------------------------------------------
-- SMART STARTUP ROUTING 
---------------------------------------------------

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local args = vim.fn.argv()

    -- Case 1: nvim → telescope current folder
    if #args == 0 then
      require("telescope.builtin").find_files({
        cwd = vim.fn.getcwd(),
        hidden = true,
        no_ignore = true,
      })
      return
    end

    local target = args[1]

    -- Case 2: nvim folder/ → project UI
    if vim.fn.isdirectory(target) == 1 then
      vim.cmd("cd " .. target)
      open_project_ui()
      return
    end

    -- Case 3: nvim file → open editor only
    -- do nothing
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
-- TREE + TELESCOPE TOGGLE
---------------------------------------------------

local project_visible = true

vim.keymap.set("n", "<A-Home>", function()
  local api = require("nvim-tree.api")

  if project_visible then
    api.tree.close()
    project_visible = false
  else
    open_project_ui()
    project_visible = true
  end
end)

---------------------------------------------------
-- HOME → jump back to editor
---------------------------------------------------

vim.keymap.set("n", "<Home>", function()
  vim.cmd("wincmd p")
end)

---------------------------------------------------
-- OPTIONAL: reload tree on directory change
---------------------------------------------------

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    require("nvim-tree.api").tree.reload()
  end,
})


---------------------------------------------------
-- BUFFER SWITCH (Shift + Home)
---------------------------------------------------

vim.keymap.set({ "n", "i" }, "<S-Home>", "<Esc><C-w>w")


---------------------------------------------------
-- TERMINAL TOGGLE (ephemeral top split)
---------------------------------------------------

local term_win = nil

local function toggle_terminal()
  -- if open → close + kill buffer
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    local buf = vim.api.nvim_win_get_buf(term_win)
    vim.api.nvim_win_close(term_win, true)
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    term_win = nil
    return
  end

  -- open new terminal at top
  vim.cmd("topleft split")
  vim.cmd("resize 12")
  vim.cmd("terminal")

  term_win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "i" }, "<A-t>", toggle_terminal)


-- delete without overwriting clipboard
vim.keymap.set({ "n", "v" }, "d", "\"_d")
vim.keymap.set({ "n", "v" }, "D", "\"_D")
vim.keymap.set({ "n", "v" }, "x", "\"_x")
vim.keymap.set({ "n", "v" }, "c", "\"_c")

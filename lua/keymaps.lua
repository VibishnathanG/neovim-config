local map = vim.keymap.set

-- Visual block fallback (terminal-safe)
map({ "n", "v" }, "<leader>v", "<C-v>")

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- Project search
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- Current folder search (NEW)
map("n", "<leader>cf", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.getcwd(),
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Find files in current folder" })

-- HOME directory search
map("n", "<leader>fh", function()
  require("telescope.builtin").find_files({
    cwd = vim.loop.os_homedir(),
    hidden = true,
    no_ignore = true,
  })
end)

-- Dynamic folder file search
map("n", "<leader>ffs", function()
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
map("n", "<leader>tss", function()
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
-- SELECT ALL / COPY / CUT / DELETE (NEW)
---------------------------------------------------

-- Select all
map("n", "<A-a>", "ggVG")

-- Copy all
map("n", "<A-c>", "ggVGy")

-- Cut all
map("n", "<A-z>", "ggVGd")

-- Delete all (no yank)
map("n", "<A-r>", "ggVG\"_d")



-- Summary
-- ff  → files in project
-- fg  → grep in project
-- fh  → files in HOME
-- ffs → files in chosen folder
-- tss → text search in chosen folder

-- space + ffs
-- → type /home/user/projects
-- → search only that folder

-- space + cf → search current folder
-- alt + a    → select all
-- alt + c    → copy all
-- alt + z    → cut all
-- alt + r    → delete all (no clipboard)

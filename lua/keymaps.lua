local map = vim.keymap.set

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- Project-local Telescope search
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- HOME directory search
map("n", "<leader>fh", function()
  require("telescope.builtin").find_files({
    cwd = vim.loop.os_homedir(),
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Find files in HOME" })

-- Full filesystem search from /
map("n", "<leader>fs", function()
  require("telescope.builtin").find_files({
    cwd = "/",
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end, { desc = "Full filesystem file search" })

-- Full filesystem text search from /
map("n", "<leader>ts", function()
  require("telescope.builtin").live_grep({
    cwd = "/",
    additional_args = function()
      return { "--hidden", "--no-ignore" }
    end,
  })
end, { desc = "Full filesystem text search" })

--ff → files in project
--fg → grep in project
--fh → files in HOME
--fs → files in system
--ts → text in system

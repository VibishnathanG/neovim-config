-- ============================================
-- TREESITTER + TELESCOPE USAGE CHEATSHEET
-- ============================================
-- space+ss → start syntax selection
-- space+si → expand syntax node
-- space+sd → shrink syntax node
--
-- vaf → select function
-- vif → inside function
-- vac → select class
-- vic → inside class
--
-- ]f / [f → next/previous function
-- ]c / [c → next/previous class
--
-- space+a / space+A → swap function parameters
--
-- :TSPlaygroundToggle → inspect syntax tree
--
-- Telescope:
-- Alt+v → open result in vertical split
-- Alt+h → open result in horizontal split
-- ============================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "HiPhish/rainbow-delimiters.nvim",
    },

    config = function()

      ---------------------------------------------------
      -- Telescope split remaps (Alt instead of Ctrl)
      ---------------------------------------------------
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<A-v>"] = actions.select_vertical,
              ["<A-h>"] = actions.select_horizontal,
            },
            n = {
              ["<A-v>"] = actions.select_vertical,
              ["<A-h>"] = actions.select_horizontal,
            },
          },
        },
      })

      ---------------------------------------------------
      -- Treesitter core setup
      ---------------------------------------------------
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua","python","bash","yaml","dockerfile","json","vim","markdown"
        },
        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>ss",
            node_incremental = "<leader>si",
            node_decremental = "<leader>sd",
          },
        },

        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },

          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },

          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },

        playground = { enable = true },
      })

      ---------------------------------------------------
      -- Rainbow bracket nesting
      ---------------------------------------------------
      require("rainbow-delimiters.setup").setup()
    end,
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua","python","bash","yaml","dockerfile","json"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}


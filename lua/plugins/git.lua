return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      vim.opt.signcolumn = "yes"

      require("gitsigns").setup({
        signs                   = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },

        signcolumn              = true,
        numhl                   = false,
        linehl                  = false,
        word_diff               = false,

        current_line_blame      = true,
        current_line_blame_opts = {
          delay = 500,
          virt_text_pos = "eol",
        },

        preview_config          = {
          border = "rounded",
        },
      })
    end,
  },
}

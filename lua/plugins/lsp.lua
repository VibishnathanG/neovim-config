return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "cmp-nvim-lsp",
      "folke/lazydev.nvim",
    },
    config = function()
      local capabilities =
        require("cmp_nvim_lsp").default_capabilities()

      require("lazydev").setup()

      local servers = {
        "lua_ls",
        "pyright",
        "bashls",
        "ansiblels",
        "dockerls",
        "yamlls",
        "jsonls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
      end

      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "gr", vim.lsp.buf.references)

      vim.diagnostic.config({
        float = { border = "rounded" },
      })
    end,
  },
}


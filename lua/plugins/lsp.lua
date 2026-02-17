return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"cmp-nvim-lsp",
			"folke/lazydev.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("lazydev").setup()

			---------------------------------------------------
			-- LSP servers
			---------------------------------------------------

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

			---------------------------------------------------
			-- Keymaps
			---------------------------------------------------

			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "gr", vim.lsp.buf.references)

			---------------------------------------------------
			-- Diagnostics UI (FIX)
			---------------------------------------------------

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 2,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰠠",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})
		end,
	},
}

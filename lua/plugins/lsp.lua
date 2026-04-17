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
			-- Current behavior: only show ERROR diagnostics.
			-- Uncomment or adjust the severity.min values below to enable WARN/INFO/HINT.
			---------------------------------------------------

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 2,
					severity = {
						min = vim.diagnostic.severity.ERROR,
					},
					-- Example: show WARN and above instead of ERROR only:
					-- severity = { min = vim.diagnostic.severity.WARN },
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
					},
					severity = {
						-- Just Remove the Below with nessary LSP action to show all signs:
						min = vim.diagnostic.severity.ERROR,
						min = vim.diagnostic.severity.WARN,
						min = vim.diagnostic.severity.INFO,
						min = vim.diagnostic.severity.HINT,
					},
					-- Example: show WARN signs as well:
					-- severity = { min = vim.diagnostic.severity.WARN },
				},
				underline = {
					severity = {
						min = vim.diagnostic.severity.ERROR,
					},
					-- Example: underline INFO and above:
					-- severity = { min = vim.diagnostic.severity.INFO },
				},
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					severity = {
						min = vim.diagnostic.severity.ERROR,
					},
					-- Example: show all severities including HINT:
					-- severity = { min = vim.diagnostic.severity.HINT },
				},
			})
		end,
	},
}

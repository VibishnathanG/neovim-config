return {
	{
		"numToStr/Comment.nvim",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local comment = require("Comment")

			comment.setup({
				mappings = false, -- disable default gc/gcc/gb etc
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})

			local api = require("Comment.api")

			-- NORMAL MODE: gc → toggle current line
			vim.keymap.set("n", "gc", function()
				api.toggle.linewise.current()
			end, { desc = "Toggle comment line" })

			-- VISUAL MODE: gc → toggle selection
			vim.keymap.set("v", "gc", function()
				local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
				vim.api.nvim_feedkeys(esc, "nx", false)
				api.toggle.linewise(vim.fn.visualmode())
			end, { desc = "Toggle comment selection" })
		end,
	},
}

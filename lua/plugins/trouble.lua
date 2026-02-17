return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Toggle diagnostics panel",
			},
			{
				"<leader>xq",
				"<cmd>Trouble quickfix toggle<cr>",
				desc = "Quickfix list",
			},
		},
	},
}

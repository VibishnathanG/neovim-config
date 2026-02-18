return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local function short_path()
				local path = vim.fn.expand("%:p")

				if path == "" then
					return "[No Name]"
				end

				local parts = vim.split(path, "/")
				local len = #parts

				if len <= 3 then
					return path
				end

				return "…/" .. parts[len - 2] .. "/" .. parts[len - 1] .. "/" .. parts[len]
			end

			require("lualine").setup({
				options = {
					theme = "kanagawa",
					globalstatus = true,
				},

				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { short_path },
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}

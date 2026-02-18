return {
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },

		config = function()
			require("dashboard").setup({
				theme = "hyper",
				shortcut_type = "letter",
				shuffle_letter = false,
				letter_list = "abcdefghiklmnopqrstuvwxyz",
				change_to_vcs_root = false,

				preview = {
					command = "bat --style=numbers --color=always",
					file_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/dashboard-nvim/static/neovim.cat",
					file_height = 11,
					file_width = 70,
				},

				config = {
					header = {
						"                           ╭──────────────────────────────────────────────────────────╮",
						"                           │                                                          │",
						"                           │    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗    │",
						"                           │    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║    │",
						"                           │    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    │",
						"                           │    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    │",
						"                           │    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║    │",
						"                           │    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝    │",
						"                           │                                                          │",
						"                           ╰──────────────────────────────────────────────────────────╯",
						"",
						"        ╭───────────────────────────────────────────────────────────────────────────────────────────────────╮",
						"        │                                                                                                   │",
						"        │   ██████╗ ██████╗ ███████╗██╗    ██╗██╗████████╗██╗  ██╗██╗   ██╗██╗██████╗ ██╗███████╗██╗  ██╗   │",
						"        │  ██╔═══██╗██╔══██╗██╔════╝██║    ██║██║╚══██╔══╝██║  ██║██║   ██║██║██╔══██╗██║██╔════╝██║  ██║   │",
						"        │  ██║   ██║██████╔╝███████╗██║ █╗ ██║██║   ██║   ███████║██║   ██║██║██████╔╝██║███████╗███████║   │",
						"        │  ██║   ██║██╔═══╝ ╚════██║██║███╗██║██║   ██║   ██╔══██║╚██╗ ██╔╝██║██╔══██╗██║╚════██║██╔══██║   │",
						"        │  ╚██████╔╝██║     ███████║╚███╔███╔╝██║   ██║   ██║  ██║ ╚████╔╝ ██║██████╔╝██║███████║██║  ██║   │",
						"        │   ╚═════╝ ╚═╝     ╚══════╝ ╚══╝╚══╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝   │",
						"        │                                                                                                   │",
						"        ╰───────────────────────────────────────────────────────────────────────────────────────────────────╯",
						"",
						"                                               ✨ ─── ⋆⋅☆⋅⋆ ─── ✨",
					},

					week_header = { enable = false },

					shortcut = {
						{ desc = "Find file", group = "@text.uri", key = "f", action = "Telescope find_files" },
						{
							desc = "New file",
							group = "@text.literal",
							key = "n",
							action = function()
								vim.cmd("enew")
							end,
						},
						{ desc = "Recent", group = "@text.reference", key = "r", action = "Telescope oldfiles" },
						{ desc = "Quit", group = "@text.danger", key = "q", action = "qa" },
					},

					packages = { enable = true },

					project = {
						enable = true,
						limit = 8,
						icon = "",
						label = "Projects",
						action = "Telescope find_files cwd=",
					},

					mru = {
						enable = true,
						limit = 10,
						icon = "",
						label = "MRU",
						cwd_only = false,
					},
				},
			})
		end,
	},
}

-- ============================================
-- TREESITTER + TELESCOPE USAGE CHEATSHEET
-- ============================================
-- <leader>ss → start syntax selection
-- <leader>si → expand syntax node
-- <leader>sd → shrink syntax node
-- vaf / vif  → outer/inner function
-- vac / vic  → outer/inner class
-- ]f / [f    → next/prev function
-- ]c / [c    → next/prev class
-- <leader>a  → swap param next
-- <leader>A  → swap param prev
-- Alt+v      → telescope vertical split
-- Alt+h      → telescope horizontal split
-- ============================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        branch = "main",   -- 0.12 requires main, not master

        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "HiPhish/rainbow-delimiters.nvim",
        },

        config = function()
            ------------------------------------------------
            -- Telescope mappings
            ------------------------------------------------
            local ok_tel, actions = pcall(require, "telescope.actions")
            if ok_tel then
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
            end

            ------------------------------------------------
            -- Treesitter — new 0.12 API (no configs.setup)
            ------------------------------------------------
            vim.treesitter.language.register("bash", "sh")

            require("nvim-treesitter").setup({
                ensure_installed = {
                    "lua",
                    "python",
                    "bash",
                    "yaml",
                    "dockerfile",
                    "json",
                    "vim",
                    "markdown",
                    "markdown_inline",
                },
                auto_install = true,
            })

            ------------------------------------------------
            -- Highlight + indent via vim.treesitter
            -- (0.12 enables these natively — no configs key)
            ------------------------------------------------
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local ok_hl = pcall(vim.treesitter.start)
                    if not ok_hl then
                        vim.bo.syntax = "on"
                    end
                end,
            })

            ------------------------------------------------
            -- Incremental selection
            ------------------------------------------------
            vim.keymap.set("n", "<leader>ss",
                function() require("nvim-treesitter.incremental_selection").init_selection() end,
                { desc = "TS: start selection" })
            vim.keymap.set("x", "<leader>si",
                function() require("nvim-treesitter.incremental_selection").node_incremental() end,
                { desc = "TS: expand node" })
            vim.keymap.set("x", "<leader>sd",
                function() require("nvim-treesitter.incremental_selection").node_decremental() end,
                { desc = "TS: shrink node" })

            ------------------------------------------------
            -- Textobjects (still uses old-style setup on its own)
            ------------------------------------------------
            local ok_to, textobjects = pcall(require, "nvim-treesitter-textobjects")
            if ok_to then
                textobjects.setup({
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
                        swap_next     = { ["<leader>a"] = "@parameter.inner" },
                        swap_previous = { ["<leader>A"] = "@parameter.inner" },
                    },
                })
            end

            ------------------------------------------------
            -- Rainbow delimiters
            ------------------------------------------------
            local ok_rb, rainbow = pcall(require, "rainbow-delimiters.setup")
            if ok_rb then
                rainbow.setup()
            end
        end,
    },
}

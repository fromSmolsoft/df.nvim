return
{
    {
        "nvim-neo-tree/neo-tree.nvim",
        event = "VeryLazy",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        },
        config = function()
            vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle reveal left<CR>", {})
            vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

            require("neo-tree").setup {
                auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
                filesystem = {
                    -- directories
                    group_empty_dirs = true, -- Concatenate path without files with only dirs
                    scan_mode = "deep",      -- Required for group_empty_dirs

                    --- hide/show files/dirs
                    filtered_items = {
                        hide_hidden = true, -- Windows specific hidden files
                        -- hide_dotfiles = false,
                        hide_by_name = {
                            ".git", ".gradle",
                            ".classpath", ".factorypath", ".settings", ".project",
                            ".idea"
                        },
                        hide_by_pattern = { "*.meta", "*/src/*/tsconfig.json", },

                        always_show = { ".gitignore", ".gitattributes", ".bashrc", },
                        always_show_by_pattern = { "*/dotfiles/.*", },

                        never_show = { ".DS_Store", "thumbs.db", },
                        never_show_by_pattern = { ".null-ls_*", },
                    },
                },
            }
        end,
    },


    {

        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            default_file_explorer = false,
            -- columns = {
            --     "icons",
            --     "size",
            --     "mtime",
            -- },
            win_options = {
                signcolumn = "yes:2",
                statuscolumn = "",
                winbar =
                "%#@attribute.builtin#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}",
            },
            view_options = {
                show_hidden = true,

                -- This function defines what is considered a "hidden" file
                -- example: https://github.com/stevearc/oil.nvim/blob/dba037598843973b8c54bc5ce0318db4a0da439d/doc/recipes.md?plain=1#L109
                -- is_hidden_file = function(name, bufnr)
                -- local m = name:match("^%.")
                -- TODO: do not hide certain files eg. .gitignored

                -- return m ~= nil
                -- end,

            },
            -- custom keymaping
            vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Oil" })
        },

        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons

    },

    {
        -- Git signs for oil.nvim
        -- I recommend not installing this a dependency of oil as it isn't required
        -- until you open an oil buffer
        "FerretDetective/oil-git-signs.nvim",
        ft = "oil",
        opts = {},
    },
}

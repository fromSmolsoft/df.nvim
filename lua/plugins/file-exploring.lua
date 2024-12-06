return
{
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
            vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
            require("neo-tree").setup {
                auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
                filesystem = {
                    group_empty_dirs = true,
                    scan_mode = "deep",
                },
            }
        end,
    },


    {

        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
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
            },
            -- custom keymaping
            vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Oil" })
        },

        -- load custom settings
        config = function(_, opts)
            require("oil").setup(opts)
        end,
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
        config = function(_, opts)
            require("oil-git-signs").setup(opts)
        end
    },
}

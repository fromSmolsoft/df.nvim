return {
    -- https://github.com/rmagatti/auto-session?tab=readme-ov-file#%EF%B8%8F-configuration
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        -- 'nvim-telescope/telescope.nvim',
        "folke/which-key.nvim", -- FIXME:removing this dependency breaks which-key plugin
    },
    keys = {
        { '<leader>sl', '<cmd>SessionSearch<CR>',         desc = 'Session search' },
        { '<leader>ss', '<cmd>SessionSave<CR>',           desc = 'Save session' },
        { '<leader>st', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },
    opts = {
        -- fixes missing localoptions at https://github.com/rmagatti/auto-session/issues/369
        (function()
            vim.o.sessionoptions =
            "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end)(),
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

        -- This will only work if Telescope.nvim is installed
        session_lens = {
            load_on_setup = true,
            theme_conf = { border = true },
            previewer = false,
            mappings = {
                -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                delete_session = { "i", "<C-D>" },
                alternate_session = { "i", "<C-S>" },
            },
        },
    },
}

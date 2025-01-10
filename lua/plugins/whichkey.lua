return {
    "folke/which-key.nvim",
    -- TODO: show F1..F12 keys if mapped
    -- TODO: describe groups 
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- referto the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function() require("which-key").show({ global = false }) end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}

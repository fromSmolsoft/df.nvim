return {
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        --- activate
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    },
    {
        "doums/darcula",
        -- priority = 1000,
        name = "darcula",

    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        -- priority = 1000,
        opts = {},
    },
    {
        "navarasu/onedark.nvim",
        -- priority = 1000,
        opts = {},
    }
}

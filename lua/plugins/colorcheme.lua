return {
    {
        "catppuccin/nvim",
        enabled = true,
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
        enabled = false,
        lazy = false,
        -- priority = 1000,
        name = "darcula",
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        lazy = false,
        -- priority = 1000,
        opts = {},
    },
    {
        "navarasu/onedark.nvim",
        enabled = false,
        -- priority = 1000,
        opts = {},
    }
}

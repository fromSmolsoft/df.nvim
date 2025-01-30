return {
    {
        "catppuccin/nvim",
        cond = true,
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
        cond = true,
        lazy = false,
        -- priority = 1000,
        name = "darcula",
    },
    {
        "folke/tokyonight.nvim",
        cond = false,
        lazy = false,
        -- priority = 1000,
        opts = {},
    },
    {
        "navarasu/onedark.nvim",
        cond = false,
        -- priority = 1000,
        opts = {},
    }
}

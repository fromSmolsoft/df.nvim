return {
    {
        -- python
        "alexpasmantier/pymple.nvim", -- https://github.com/alexpasmantier/pymple.nvim
        -- Pymple adds missing common Python IDE features for Neovim when dealing with imports
        -- requires [grip-grab](https://github.com/alexpasmantier/grip-grab) which has to be installed by cargo
        -- disabling for now until it supports `rg`
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- optional (nicer ui)
            "stevearc/dressing.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        build = ":PympleBuild",
        opts = {},
        -- `require("pymple").setup()` most likely not needed as lazy plug manager setup automatically
        -- config = function()
        --   require("pymple").setup()
        -- end,
    },
}

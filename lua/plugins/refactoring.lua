return {
    {
        "ThePrimeagen/refactoring.nvim",
        enabled = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        -- lazy = false,
        opts = function()
            local wk = require("which-key")
            if wk ~= nil then wk.add({ "<leader>r", group = "Refactor" }) end
            vim.keymap.set("x", "<leader>re", ":Refactor extract ")
            vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
            vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
            vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
            vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
            vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
            vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
        end,
        -- },
    },
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

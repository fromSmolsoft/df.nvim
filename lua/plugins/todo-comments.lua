return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    vim.keymap.set("n", "<leader>tt", ":TodoTelescope<CR>", { desc = "TODO Telescope" }),
    vim.keymap.set("n", "<leader>tl", ":TodoLocList<CR>", { desc = "TODO List" }),
    -- vim.keymap.set("n", "<leader>tf", ":TodoQuickFix<CR>", { desc = "TODO QuickFix" }),

}

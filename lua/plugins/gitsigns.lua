return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {}),
            vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {}),
        },
    }
}

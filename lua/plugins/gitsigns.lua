return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk (Gitsigns)" }),
            vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunks (Gitsigns)" }),
            vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>",
                { desc = "Toogle blame (Gitsigns)" }),
        },
    }
}

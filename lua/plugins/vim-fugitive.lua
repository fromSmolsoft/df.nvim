return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gg", ":Git<CR>", { desc = "Git -fugitive" })
        end
    }
}

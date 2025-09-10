return {
    "jsstevenson/nvim-tmux", -- edit Tmux configuration https://github.com/jsstevenson/nvim-tmux
    -- event = "VeryLazy",
    ft = "tmux",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- your configuration comes here
        vim.keymap.set("n", "K", "<Plug>(tmux_show_man_floatwin)",
            { silent = true, remap = true, desc = "Tmux man page" }) -- FIXME: mapping is overridden by lsp key map for hover
        vim.keymap.set("n", "<leader>K", "<Plug>(tmux_show_man_floatwin)",
            { silent = true, remap = false, desc = "Tmux man page" })
        vim.keymap.set("n", "g!!", "<Plug>(tmux_execute_cursorline)",
            { silent = true, remap = false, desc = "Tmux exec cursorline" })
        vim.keymap.set("v", "g!", "<Plug>(tmux_execute_selection)",
            { silent = true, remap = false, desc = "Tmux exec cursorline" })
    end
}

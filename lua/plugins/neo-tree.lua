return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
        vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
        require("neo-tree").setup {
            auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
        }
    end,

    -- todo: Automatically close Neotree - doesn't work
    -- commands = {
    --     open_nofocus = function (state)
    --         require("neo-tree.sources.filesystem.commands").open(state)
    --         vim.schedule(function ()
    --             vim.cmd([[Neotree close]])
    --         end)
    --     end,
    -- }
}

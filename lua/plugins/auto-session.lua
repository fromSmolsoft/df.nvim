return {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "folke/which-key.nvim",
        -- FIXME: which-key.nvim groups is not added
        optional = true,
        opts = {
            defaults = {
                ["<leader>s"] = { name = "Session" },
            },
        },
    },
    keys = {
        -- require("which-key").add({ "<leader>s", group = "Sessions" }),

        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { "<leader>sl", "<cmd>SessionSearch<CR>",         desc = "Session search" },
        { "<leader>ss", "<cmd>SessionSave<CR>",           desc = "Save session" },
        { "<leader>st", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    },
    opts = {
        lazy_support = true,
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- ⚠️ This will only work if Telescope.nvim is installed
        -- The following are already the default values, no need to provide them if these are already the settings you want.
        session_lens = {
            -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
            load_on_setup = true,
            theme_conf = { border = true },
            previewer = false,
            mappings = {
                -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                delete_session = { "i", "<C-D>" },
                alternate_session = { "i", "<C-S>" },
            },
        },
    },
}

return {
    "folke/todo-comments.nvim",
    -- https://github.com/folke/todo-comments.nvim

    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        keywords = {
            FIX = {
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
        },
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        highlight = {
            -- pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
            pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
        },
        search = {
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            -- pattern = [[\b(KEYWORDS):]],
            pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives

        }
    },
    vim.keymap.set("n", "<leader>tt", ":TodoTelescope<CR>", { desc = "TODO Telescope" }),
    vim.keymap.set("n", "<leader>tl", ":TodoLocList<CR>", { desc = "TODO List" }),
    -- vim.keymap.set("n", "<leader>tf", ":TodoQuickFix<CR>", { desc = "TODO QuickFix" }),

}

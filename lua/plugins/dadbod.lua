return {

    { -- Interacting with databases. https://github.com/tpope/vim-dadbod
        "tpope/vim-dadbod", lazy = true },
    {
        -- Auto-completion using dadbod database connection. https://github.com/kristijanhusak/vim-dadbod-completion.
        -- Used as source in nvim-cmp.
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true
    }, -- Optional
    {
        -- UI for dadbod.  https://github.com/kristijanhusak/vim-dadbod-ui
        "kristijanhusak/vim-dadbod-ui",
        -- ft = { "sql", "mysql", "plsql" },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    }
}

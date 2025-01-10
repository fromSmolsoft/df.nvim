return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua",
                "java", "groovy", "sql", "properties", -- Java
                "html", "xml",
                "vim", "vimdoc",
                "bash", "typescript", "javascript", "python",
                "markdown",
                "gitignore", "gitcommit", "tmux",
                "ini", "yaml", "toml"
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            function()
                vim.wo.foldmethod = 'expr'
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end
        },
    }
}

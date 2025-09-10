return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            auto_install = true,
            ensure_installed = {
                -- not installed by auto_install
                "regex", "markdown_inline", "comment", "luadoc",

                -- scripting
                "lua", "bash", "python", "vim",

                -- java projects
                -- "java", "groovy", "sql", "properties",

                -- web
                -- "html", "xml", "typescript", "javascript",

                -- docs
                -- "vimdoc", "markdown", "gitignore", "gitcommit",

                -- configurations
                -- "tmux", "ini", "yaml", "toml",
            },
            highlight = { enable = true },
            indent = { enable = true },
            function()
                -- vim.wo.foldmethod = 'expr'
                -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end
        },
    }
}

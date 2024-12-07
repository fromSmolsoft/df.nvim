return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "lua", "java", "html", "vim", "vimdoc", "bash", "javascript", "python", "xml", "markdown", "groovy",  "gitignore", "gitcommit"},
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    }
}

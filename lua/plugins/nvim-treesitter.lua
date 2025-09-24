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

                -- -- java projects
                -- "java", "groovy", "sql", "properties",

                -- -- web
                -- "html", "xml", "typescript", "javascript", "tsx", "jsx",

                -- -- docs
                -- "vimdoc", "markdown", "gitignore", "gitcommit",

                -- -- configurations
                -- "tmux", "ini", "yaml", "toml",
            },
            highlight = { enable = true },
            indent = { enable = true },
            matchup = { enable = true }, -- Enable vim-matchup integration

            --- Install parsers on-demand when opening files. Replaces unreliable auto_install.
            function()
                vim.api.nvim_create_autocmd("BufEnter", {
                    callback = function()
                        local ft = vim.bo.filetype
                        if not ft then return end

                        local parsers = require("nvim-treesitter.parsers")
                        local parser = parsers.filetype_to_parsername[ft]
                        if not parser then return end

                        local is_installed = parsers.has_parser(parsers.ft_to_lang(ft))
                        if not is_installed then
                            vim.cmd("TSInstall " .. parser)
                        end
                    end,
                })
            end
        },
    }
}

return {
    {
        --- nvim-cmp source for neovim's built-in language server client. https://github.com/hrsh7th/cmp-nvim-lsp
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        --- https://github.com/L3MON4D3/LuaSnip
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        -- build = "make install_jsregexp",
    },
    {
        {
            --- Create annotations. https://github.com/danymat/neogen
            "danymat/neogen",
            config = function()
                vim.keymap.set(
                    "n", "<Leader>cn", ":lua require('neogen').generate()<CR>",
                    { noremap = true, silent = true, desc = "Generate annotation (neogen)" })
            end,
            version = "*", -- "*" is stable versions
        }

    },
    {
        --- gitcommit autocompletion
        "petertriho/cmp-git",
        -- ft = { "gitcommit", "octo", "NeogitCommitMessage" },
        opt = {},
        init = function()
            table.insert(require("cmp").get_config().sources, { name = "git" })
        end

    },

    {
        --- A completion engine, https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter" },
        config = function()
            local cmp = require("cmp")
            local neogen = require("neogen")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    -- neogen mapping
                    ["<tab>"] = cmp.mapping(function(fallback)
                        if neogen.jumpable() then
                            neogen.jump_next()
                        else
                            fallback()
                        end
                    end, { "i", "s", }),
                    ["<S-tab>"] = cmp.mapping(function(fallback)
                        if neogen.jumpable(true) then
                            neogen.jump_prev()
                        else
                            fallback()
                        end
                    end, { "i", "s", }),
                }),

                -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "codeium" },
                }, {
                    { name = 'buffer' },
                })
            })
            -- databases, sql... , plugin vim-dadbod (autocompletion when accessing databases)
            cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
                sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "vim-dadbod-completion" },
                        { name = 'sql' },
                        { name = "codeium" },
                    },
                    { { name = 'buffer' }, })
            })

            -- git
            cmp.setup.filetype({ "gitcommit", "octo", "NeogitCommitMessage" }, {

                sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = 'git' },
                        { name = "codeium" },
                    },
                    { { name = 'buffer' },
                    }),
            })

            -- tmux
            cmp.setup.filetype({ "tmux" }, {
                sources = cmp.config.sources({
                        { name = 'tmux' },
                        { name = "codeium" },
                        { name = "path" },
                    },
                    { { name = 'buffer' }, })
            })
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "L3MON4D3/LuaSnip",

            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            { "ray-x/cmp-sql",          ft = { "sql", "mysql", "plsql" } },
            { "andersevenrud/cmp-tmux", ft = { "tmux" } }, -- tmux
        },
    },
}

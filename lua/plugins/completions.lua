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
    },
    {
        {
            --- Create annotations, https://github.com/danymat/neogen
            "danymat/neogen",
            config = true,
            -- Uncomment next line if you want to follow only stable versions
            version = "*",
        }

    },
    {
        --- A completion engine, https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            local neogen = require('neogen')
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
                sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" }, -- For luasnip users.
                        { name = 'nvim_lsp_signature_help' },
                    },
                    { { name = "buffer" }, }),
            })
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "L3MON4D3/LuaSnip",
        },
    },
}

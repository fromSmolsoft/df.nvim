return
{
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {},
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            ensure_installed = { "taplo", "lua_ls", "jdtls", "marksman", "ruff", "pyright" },
            auto_install = true,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            -- capabilities: deprecated but `usePlaceholders` work eg. `prin` auto-completes to  `print()`
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

            -- capabilities: new way, no need for `make_client_capabilities()`
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local lspconfig = require("lspconfig")

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "Lsp Actions",
                callback = function(event)
                    print("Lsp Attached")

                    -- keymaps
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)

                    vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, { desc = "Format" })
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
                    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Definition" })
                    vim.keymap.set("n", "<leader>grr", vim.lsp.buf.references, { desc = "Reference" })
                    vim.keymap.set("n", "<leader>grn", vim.lsp.buf.rename, { desc = "Rename references" })
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

                    -- configure lsp in-line diagnostics
                    vim.diagnostic.config({
                        severity_sort = true,
                        virtual_text = false,
                        signs = true,
                        underline = true,
                        float = {
                            source = "if_many"
                        },
                    })

                    -- floating window diagnostics
                    vim.o.updatetime = 250
                    vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

                    -- toggling diagnostics
                    local function togle_diagnostics()
                        if vim.diagnostic.is_enabled() then
                            vim.diagnostic.enable(false)
                            vim.diagnostic.reset()
                            vim.notify("diagnostics disabled") --print to status bar
                        else
                            vim.diagnostic.enable(true)
                            vim.notify("diagnostics enabled")
                            -- Show line diagnostics automatically in hover window
                        end
                    end

                    vim.keymap.set('n', '<leader>td', togle_diagnostics, { desc = "disgnostic toogle" })

                    -- TODO: reference highlighting
                    -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight(nil, {focus=false, scope="cursor"})]]
                end
            })

            -- setup servers that share same configuration in loop
            local servers = {
                "marksman",
                --"jdtls", -- jdtls has it's own plugin
                "pyright", "ruff", "ts_ls", "html", "bashls", "taplo", "sqls", "powershell_es",
                "gradle_ls" }
            for _, lsp in pairs(servers) do
                lspconfig[lsp].setup {
                    capabilities = capabilities,
                    init_options = {
                        -- Most likely not needed anymore due to capabilities' config
                        usePlaceholders = true,
                    },
                }
            end

            -- individual server configuration
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        init_options = {
                            -- Most likely not needed anymore due to capabilities' config
                            usePlaceholders = true,
                        },
                        diagnostics = {
                            globals = { "vim", "describe", "it", "before_each", "after_each" },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },

                        -- By default, lua-language-server sends anonymized data to its developers. Stop it using the following.
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
    },

    {
        "ray-x/lsp_signature.nvim", -- Show doc strings upon hover
        -- FIX: Hover doesn't show doc-string, status bar writes "No information available"
        enabled = true,
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require "lsp_signature".setup(opts)
        end,
    },

    {
        "nvimtools/none-ls.nvim", -- provides hook for non-lsp tools to hook into its lsp client (linters,formatters,..)
        enabled = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- formatting
                    -- null_ls.builtins.formatting.stylua, -- lua
                    null_ls.builtins.formatting.prettier,    -- angular, css, flow, graphql, html, json, jsx, javascript, less, markdown, scss, typescript, vue, yaml
                    null_ls.builtins.formatting.shellharden, -- bash
                    null_ls.builtins.formatting.shfmt,       -- bash

                    -- diagnostics
                    null_ls.builtins.diagnostics.npm_groovy_lint.with({ filetypes = { "groovy", "Jenkinsfile" } }), -- groovy, filetypes has to specifically not include java or it lints Java in weird way

                    -- null_ls.builtins.diagnostics.shellcheck,      -- deprecated,  bash

                    --code_actions
                    null_ls.builtins.code_actions.gitsigns, -- gitsisgns

                    --hover
                    null_ls.builtins.hover.printenv, -- sh, dosbatch, ps1
                },
            })
        end,
    },
}

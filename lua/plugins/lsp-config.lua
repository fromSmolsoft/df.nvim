return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {
            -- ensure_installed = { "java-debug-adapter", "java-test" }
        },
        config = function(_, opts)
            require("mason").setup(opts)
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "taplo",
                "lua_ls",
                "jdtls",
                "marksman",
                "ruff",
            },
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
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })

            lspconfig.marksman.setup({
                capabilities = capabilities,
            })

            -- lspconfig.java.setup({
            --     capabilities = capabilities })

            lspconfig.jdtls.setup({
                jdtls = function()
                    return true
                end,
            })

            -- lspconfig.ast_grep.setup({
            -- Very complex setup.
            --  - Every individual project has to include extensive file structure for every single rule for every library that is given by other tool by default. There doesn't seem to be any defaul rule setting available ATM.
            --     -- "c", "cpp", "rust", "go", "java", "python", "javascript", "typescript", "html", "css", "kotlin", "dart", "lua"
            --     capabilities = capabilities,
            -- })

            lspconfig.pyright.setup({
                -- python
                capabilities = capabilities,
            })

            lspconfig.ruff.setup({
                -- python
                -- FIX: buff received invalid settings, falling back to default settings
                capabilities = capabilities,
                init_options = {
                    settings = {
                        -- Ruff language server settings go here
                    }
                },
            })

            lspconfig.ts_ls.setup({
                -- Typescript ls
                capabilities = capabilities,
            })

            lspconfig.html.setup({
                capabilities = capabilities,
            })

            lspconfig.bashls.setup({
                capabilities = capabilities,
            })

            lspconfig.taplo.setup({
                -- toml
                capabilities = capabilities,
            })

            lspconfig.sqls.setup({
                capabilities = capabilities,
            })

            lspconfig.powershell_es.setup({
                capabilities = capabilities,
            })

            -- lspconfig.groovyls.setup({
            --     capabilities = capabilities,
            -- })

            lspconfig.gradle_ls.setup({
                -- Gradle ls https://github.com/microsoft/vscode-gradle
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gradle_ls
                capabilities = capabilities,
            })

            vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, { desc = "Format" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Definition" })
            vim.keymap.set("n", "<leader>grr", vim.lsp.buf.references, { desc = "Reference" })
            vim.keymap.set("n", "<leader>grn", vim.lsp.buf.rename, { desc = "Rename references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

            -- configure lsp line diagnostics
            vim.diagnostic.config({
                severity_sort = true,
                virtual_text = false,
                signs = true,
                underline = true,
                float = {
                    source = "if_many"
                }
            })

            -- toggle diagnostics
            vim.keymap.set('n', '<leader>td', function()
                    if vim.diagnostic.is_enabled() then
                        vim.diagnostic.enable(false)
                        vim.diagnostic.reset()

                        -- Show line diagnostics automatically in hover window
                        vim.o.updatetime = 250
                        vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

                        vim.notify("diagnostics disabled") --print to status bar
                    else
                        vim.diagnostic.enable(true)
                        vim.notify("diagnostics enabled")
                    end
                end,
                -- { silent = true, noremap = true },
                { desc = "disgnostic toogle" })
        end,
    },
    {
        "ray-x/lsp_signature.nvim", -- Show doc strings upon hover
        -- FIX: Hover doesn't show doc-string, status bar writes "No information available"
        enabled = true,
        -- event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require "lsp_signature".setup(opts)
        end,

        -- load on lsp buffer attaching
        -- FIX: trows error Attempt to get length of local 'spec'
        -- vim.api.nvim_create_autocmd("LspAttach", {
        --     callback = function(args)
        --         local bufnr = args.buf
        --         local client = vim.lsp.get_client_by_id(args.data.client_id)
        --         if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
        --             return
        --         end
        --         require("lsp_signature").on_attach({
        --             -- ... setup options here ...
        --         }, bufnr)
        --     end,
        -- })
    },
    {
        "nvimtools/none-ls.nvim", -- provides hook for non-lsp tools to hook into its lsp client (linters,formatters,..)
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
                    null_ls.builtins.diagnostics.npm_groovy_lint, -- groovy
                    -- null_ls.builtins.diagnostics.shellcheck,      -- deprecated,  bash

                    --code_actions
                    null_ls.builtins.code_actions.gitsigns, -- gitsisgns

                    --hover
                    null_ls.builtins.hover.printenv, -- sh, dosbatch, ps1
                },
            })

            -- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        end,
    },
}

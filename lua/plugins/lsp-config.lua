return
{
    {
        "williamboman/mason.nvim", -- https://github.com/williamboman/mason.nvim
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim", -- https://github.com/williamboman/mason-lspconfig.nvim
        opts = {
            ensure_installed = { "lua_ls", "jdtls", "marksman", "ruff", "pyright", "taplo" },
            auto_install = true,

            -- use alongside `nvim-jdtls` plugin
            function(server_name)
                -- skip jdtls setup by mason-lspconfig.nvim
                if server_name == "jdtls" then
                    vim.notify("mason-lspconfig: skipping jdtls")
                    return true
                end
            end
        },
    },
    {
        "nvim-java/nvim-java", -- https://github.com/nvim-java/nvim-java
        cond = false,          -- not to be used alongside nvim-jdtls
        -- FIX: trows error when configuring dap despite dap being diabled
        -- FIX: Gradle project resolve imports can't be resolved etc.
        config = function()
            require('java').setup({
                java_debug_adapter = { enable = false, },
            })
        end
    },
    {
        ---  switching custom lsp configurations per project or globally by loading json
        "folke/neoconf.nvim", -- https://github.com/folke/neoconf.nvim
        cond = false,
        opts = {
            --   - global settings: ~/.config/nvim/neoconf.json
            --   - local settings: ~/projects/foobar/.neoconf.json
        },
        -- config = function()
        --     require("neoconf").setup({
        --         -- override any of the default settings here
        --     })
        -- end
    },
    {
        "neovim/nvim-lspconfig", -- https://github.com/neovim/nvim-lspconfig
        -- dependencies = { "folke/neoconf.nvim", "nvim-java/nvim-java", },

        -- config fun. used by lazy-nvim to setup plugins
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            local lspconfig = require("lspconfig")
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "Lsp Actions",
                callback = function(event)
                    -- keymaps
                    local opts = { buffer = event.buf }
                    --- create which key groups
                    local whichkey_groups = function()
                        local wk = require("which-key")
                        if wk ~= nil then
                            wk.add({ "<leader>g", group = "Lsp" })
                            wk.add({ "<leader>gr", group = "Reference" })
                            wk.add({ "<leader>c", group = "Code" })
                        end
                    end
                    whichkey_groups()
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
                            vim.notify("𐄂 Diagnostics disabled") --print to status bar
                        else
                            vim.diagnostic.enable(true)
                            vim.notify("✅ Diagnostics enabled")
                        end
                    end

                    vim.keymap.set('n', '<leader>td', togle_diagnostics, { desc = "disgnostic toogle" })

                    -- TODO: reference highlighting
                    -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight(nil, {focus=false, scope="cursor"})]]
                end
            })

            -- list of servers sharing same (default) configuration
            local servers = {
                -- "jdtls", -- don't setup jdtls if nvim-jdtls is used
                "marksman",
                "pyright", "ruff",
                "ts_ls", "html", "bashls",
                "taplo", "powershell_es",
                "gradle_ls",
                "lemminx",
            }

            for _, lsp in pairs(servers) do
                lspconfig[lsp].setup {
                    capabilities = capabilities,
                    init_options = {
                        -- Most likely not needed anymore due to capabilities' config
                        usePlaceholders = true,
                    },
                }
            end

            -- sqls custom config (requires db connection)
            -- lspconfig.sqls.setup({
            --     on_attach = function(client, _)
            --         capabilities = capabilities
            --         client.server_capabilities.documentFormattingProvider = false
            --         client.server_capabilities.documentRangeFormattingProvider = false
            --     end,
            -- })

            -- lua_ls custom config
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        init_options = {
                            -- Most likely not needed anymore due to capabilities' config
                            usePlaceholders = true,
                        },
                        diagnostics = { globals = { "vim", "describe", "it", "before_each", "after_each" }, },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },

                        -- By default, lua-language-server sends anonymized data to its developers. Stop it using the following.
                        telemetry = { enable = false, },
                    },
                },
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim", -- Show doc strings upon hover
        enabled = true,
        event = "VeryLazy",
        opts = {},
        -- config = function(_, opts) require "lsp_signature".setup(opts) end,
    },
    {
        "nvimtools/none-ls.nvim", -- provides hook for non-lsp tools to hook into its lsp client (linters,formatters,..)
        enabled = true,
        dependencies = { "nvim-lua/plenary.nvim", lazy = true },
        config = function()
            local null_ls = require("null-ls")


            local sql_ft = { "sql", }
            local sqlfluff_args = { "--dialect", "postgres" }
            local groovy = { "groovy", "Jenkinsfile" }
            local markdown = { "markdown", "org" }
            local prettier_ft = {
                "javascript", "javascriptreact", "typescript", "typescriptreact",
                "css", "scss", "less", "html", "htmlangular",
                "json", "jsonc", "yaml",
                "markdown", "markdown.mdx", "graphql", "handlebars",
                "svelte", "vue", "astro"
            }
            local sh_ft = { "sh", }

            -- key is none_ls builtins', value is package name in mason_registry. Packages can be duplicated.
            local builtins_to_mason = {

                -- formatters
                prettier = "prettier",
                cbfmt = "cbfmt",
                npm_groovy_lint = "npm-groovy-lint",
                shellharden = "shellharden",
                shfmt = "shfmt",
                sqlfluff = "sqlfluff",

                -- diagnostics
                npm_groovy_lint = "npm-groovy-lint",
                sqlfluff = "sqlfluff",

                -- code_actions
                "gitsigns", -- not in mason_registry

                -- hovers
                "printenv", -- not in mason_registry
            }

            local mason_registry = require("mason-registry")
            local missing_mason_packages, missing_mason_packages_msg = {}, "Missing packages: "

            --- in given list find Mason packages that were not yet installed
            --- @param tools to ensure being installed
            local function get_missing_packages(tools)
                for _, value in pairs(tools) do
                    if (mason_registry.has_package(value) and not mason_registry.is_installed(value)) then
                        missing_mason_packages[#missing_mason_packages + 1] = value
                        missing_mason_packages_msg = missing_mason_packages_msg .. value .. ", "
                    end
                end
            end

            get_missing_packages(builtins_to_mason)

            --- Install mason given packages command `MasonInstall `
            --- @param packages list of packages to be installed
            local function install_mason_packages(packages)
                if #packages > 0 then
                    vim.notify(missing_mason_packages_msg)
                    vim.cmd { cmd = "MasonInstall", args = packages }
                end
            end

            install_mason_packages(missing_mason_packages)

            null_ls.setup({
                sources = {

                    -- formatting --
                    null_ls.builtins.formatting.prettier.with({ filetypes = prettier_ft }),
                    null_ls.builtins.formatting.cbfmt.with({ filetypes = markdown }), -- format code blocks in markdown``
                    null_ls.builtins.formatting.npm_groovy_lint.with({ filetypes = groovy }),

                    null_ls.builtins.formatting.shellharden.with({ filetypes = sh_ft }),
                    null_ls.builtins.formatting.shfmt.with({ filetypes = sh_ft }),

                    null_ls.builtins.formatting.sqlfluff.with({
                        filetypes = sql_ft,
                        extra_args = sqlfluff_args, -- change to your dialect
                    }),

                    -- diagnostics --
                    null_ls.builtins.diagnostics.npm_groovy_lint.with({
                        filetypes = groovy,
                        disabled_filetypes = { "java" }, -- filetypes has to specifically not include java or it lints Java in weird way
                    }),
                    null_ls.builtins.diagnostics.sqlfluff.with({
                        filetypes = sql_ft,
                        extra_args = sqlfluff_args, -- change to your dialect
                    }),

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

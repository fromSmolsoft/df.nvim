-- Localization of globals
local vim = vim
local vim_api = vim.api
local notify = vim.notify
local Lsp_augrp = vim_api.nvim_create_augroup("lsp_augrp", { clear = false })
local mason_registry = require("mason-registry")

---Mason package item.
---@param name string name of mason package eg. `"lua_ls"`
---@param ...table Optional package configuration
---@return table package_and_config `{name, configuration}`
local function create_pckg(name, ...)
    local config = ...
    return { name = name, configuration = config or {} }
end

---Verify whether package is in mason-registry and is installed at the same time.
---@param name string name of the mason package
---@return boolean
local function is_mason_package(name)
    return (mason_registry.has_package(name) and not mason_registry.is_installed(name))
end

---Get Mason packages that are not installed.
---@param pckgs_names table list of package names
---@return table missing_packages as list of strings
local function get_missing_packages(pckgs_names)
    if pckgs_names == nil then return {} end
    local missing_pckgs = {}
    if type(pckgs_names) == "string" then
        if is_mason_package(pckgs_names) then missing_pckgs[#missing_pckgs + 1] = pckgs_names end
        return missing_pckgs
    end
    for _, value in pairs(pckgs_names) do
        if is_mason_package(value) then missing_pckgs[#missing_pckgs + 1] = value end
    end
    return missing_pckgs
end

---Install list of mason packages by command `:MasonInstall package1 package2 ... <CR>`
---@param packages table list of packages names strings
local function install_mason_packages(packages)
    if #packages > 0 then
        vim.cmd { cmd = "MasonInstall", args = packages }
    end
end

-- plugins
return
{
    {
        "williamboman/mason.nvim", -- https://github.com/williamboman/mason.nvim
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim", -- https://github.com/williamboman/mason-lspconfig.nvim
        opts = {
            -- Automatically installed servers. eg. { "lua_ls", "jdtls", "marksman", "ruff", "pyright", "taplo" },
            ensure_installed = { "lua_ls", },

            -- (not reliable)Supposed to auto-install servers after they are set up
            automatic_installation = true,

            -- use alongside `nvim-jdtls` plugin
            function(server_name)
                -- skip jdtls autonomous setup by mason-lspconfig.nvim
                if server_name == "jdtls" then
                    notify("mason-lspconfig: skipping jdtls")
                    return true
                end
            end
        },
    },
    {
        -- https://github.com/folke/neoconf.nvim, switching custom lsp configurations per project or globally by loading json
        "folke/neoconf.nvim",
        enabled = false,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig", -- https://github.com/neovim/nvim-lspconfig
        -- dependencies = { "folke/neoconf.nvim", },

        -- config fun. used by lazy-nvim to setup plugins
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            -- enhanced folding with "nvim-ufo"
            -- capabilities.textDocument.foldingRange = {
            --     dynamicRegistration = false,
            --     lineFoldingOnly = true
            -- }
            local lspconfig = require("lspconfig")
            vim_api.nvim_create_autocmd("LspAttach", {
                group = Lsp_augrp,
                desc = "Lsp Actions",
                callback = function(event)

                    -- Key-mapping
                    local opts = { buffer = event.buf }
                    --- create which key groups
                    local whichkey_groups = function()
                        local wk = require("which-key")
                        if wk ~= nil then
                            wk.add({ "<leader>g", group = "lsp" })
                            wk.add({ "gr", group = "lsp" })
                            wk.add({ "<leader>gr", group = "lsp/reference" })
                            wk.add({ "<leader>c", group = "code" })
                        end
                    end
                    whichkey_groups()
                    local keymap = vim.keymap
                    -- keymap.set("n", "<leader>gri", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                    keymap.set("n", "<leader>gri", vim.lsp.buf.implementation, { desc = "implementation" })
                    keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, { desc = "format" })
                    keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover" })
                    keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "definition" })
                    keymap.set("n", "<leader>grr", vim.lsp.buf.references, { desc = "reference" })
                    keymap.set("n", "<leader>grn", vim.lsp.buf.rename, { desc = "rename" })
                    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "actions" })
                    keymap.set({ "n", "v" }, "<leader>gra", vim.lsp.buf.code_action, { desc = "actions" })

                    -- configure lsp in-line diagnostics
                    local diagnostic = vim.diagnostic
                    diagnostic.config({
                        severity_sort = true,
                        virtual_text = false,
                        signs = true,
                        underline = true,
                        float = {
                            source = "if_many"
                        },
                    })
                    -- diagnostics - floating window
                    vim.o.updatetime = 300
                    vim_api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        group = Lsp_augrp,
                        pattern = "*",
                        callback = function() diagnostic.open_float(nil, { focus = false, scope = "cursor" }) end,
                    })
                    -- diagnostics - toggling
                    local function togle_diagnostics()
                        if diagnostic.is_enabled() then
                            diagnostic.enable(false)
                            diagnostic.reset()
                            notify("𐄂 Diagnostics disabled") --print to status bar
                        else
                            diagnostic.enable(true)
                            notify("✅ Diagnostics enabled")
                        end
                    end

                    keymap.set('n', '<leader>td', togle_diagnostics, { desc = "disgnostic toogle" })

                    -- TODO: reference highlighting
                    -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight(nil, {focus=false, scope="cursor"})]]
                end
            })

            -- common default configuration for language servers
            local ls_default_conf = {
                capabilities = capabilities,
                init_options = {
                    -- Most likely not needed anymore due to capabilities' config
                    usePlaceholders = true,
                },
            }

            -- all ls mason names and their configurations
            local lsps = {
                create_pckg("jdtls", {}),
                create_pckg("marksman", ls_default_conf),
                create_pckg("pyright", ls_default_conf),
                create_pckg("ruff", ls_default_conf),
                create_pckg("ts_ls", ls_default_conf),
                create_pckg("html", ls_default_conf),
                create_pckg("bashls", ls_default_conf),
                create_pckg("taplo", ls_default_conf),
                create_pckg("powershell_es", ls_default_conf),
                create_pckg("gradle_ls", ls_default_conf),
                create_pckg("lemminx", ls_default_conf),
                create_pckg("harper_ls", ls_default_conf),
                create_pckg("lua_ls", {
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
                                library = vim_api.nvim_get_runtime_file("", true),
                            },
                            telemetry = { enable = false, },
                        },
                    },
                }),
                create_pckg("sqls", {
                    on_attach = function(client, _)
                        capabilities = capabilities
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                }),
            }

            local get_package_names = function(ls_list)
                local package_names = {}
                for _, value in pairs(ls_list) do
                    local name = value.name
                    package_names[#package_names + 1] = name
                end
                return package_names
            end

            ---batch call setup_ls()
            ---@param ls_list table list of mason_packages eg. `packages = { item1 = {name = "name", config = {}}, item2..., item3.., .... }`
            local setup_ls_in_batch = function(ls_list)
                for _, value in pairs(ls_list) do
                    local name, conf = value.name, value.configuration
                    if conf == true or next(conf) ~= nil then lspconfig[name].setup(conf) end
                end
            end

            local package_names = get_package_names(lsps)
            install_mason_packages(get_missing_packages(package_names))
            setup_ls_in_batch(lsps)
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
                gitlint = "gitlint",

                -- code_actions
                "gitsigns", -- not in mason_registry

                -- hovers
                "printenv", -- not in mason_registry
            }

            install_mason_packages(get_missing_packages(builtins_to_mason))

            local null_formatter = null_ls.builtins.formatting
            local null_diagnostics = null_ls.builtins.diagnostics
            local null_actions = null_ls.builtins.code_actions
            local null_hover = null_ls.builtins.hover

            null_ls.setup({
                sources = {
                    -- formatting --
                    null_formatter.prettier.with({ filetypes = prettier_ft }),
                    null_formatter.cbfmt.with({ filetypes = markdown }), -- format code blocks in markdown``
                    null_formatter.npm_groovy_lint.with({ filetypes = groovy }),

                    null_formatter.shellharden.with({ filetypes = sh_ft }),
                    null_formatter.shfmt.with({ filetypes = sh_ft }),

                    null_formatter.sqlfluff.with({
                        filetypes = sql_ft,
                        extra_args = sqlfluff_args, -- change to your dialect
                    }),

                    -- diagnostics --
                    null_diagnostics.npm_groovy_lint.with({
                        filetypes = groovy,
                        disabled_filetypes = { "java" }, -- filetypes has to specifically not include java or it lints Java in weird way
                    }),
                    null_diagnostics.gitlint,
                    null_diagnostics.sqlfluff.with({
                        filetypes = sql_ft,
                        extra_args = sqlfluff_args, -- change to your dialect
                    }),

                    -- null_diagnostics.shellcheck,      -- deprecated,  bash

                    --code_actions
                    -- null_actions.gitsigns, -- gitsisgns

                    --hover
                    null_hover.printenv, -- sh, dosbatch, ps1
                },
            })
        end,
    },
}

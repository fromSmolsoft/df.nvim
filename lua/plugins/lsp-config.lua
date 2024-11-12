return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = { ensure_installed = { "java-debug-adapter, java-test" } },
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
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

            -- Typescript ls
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            -- Ruby inteli sense ls
            -- lspconfig.solargraph.setup({
            -- 	capabilities = capabilities,
            -- })

            lspconfig.html.setup({
                capabilities = capabilities,
            })

            lspconfig.bashls.setup({
                capabilities = capabilities,
            })

            lspconfig.sqls.setup({
                capabilities = capabilities,
            })

            lspconfig.powershell_es.setup({
                capabilities = capabilities,
            })

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

            vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, { desc = "Format" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Definition" })
            vim.keymap.set("n", "<leader>grr", vim.lsp.buf.references, { desc = "Reference" })
            vim.keymap.set("n", "<leader>grn", vim.lsp.buf.rename, { desc = "Rename references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

            -- Show line diagnostics automatically in hover window
            vim.o.updatetime = 250
            vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
            vim.diagnostic.config({
                severity_sort = true,
            })
        end,
    },

    {
        -- Show doc strings upon hover
        -- FIX: Hover doesn't show doc-string, status bar writes "No information available"
        "ray-x/lsp_signature.nvim",
        enabled = true,
        event = "VeryLazy",
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
}

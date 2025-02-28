return {
    "mfussenegger/nvim-lint",
    cond = false, -- null-ls deprecated shellcheck, purpose of this plugin was to lint `bash` but `shellcheck` seems to be linting regardless any plugin configuring => disabling the plugin for tim e
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            -- javascript = { "eslint_d" },
            -- typescript = { "eslint_d" },
            -- javascriptreact = { "eslint_d" },
            -- typescriptreact = { "eslint_d" },
            -- svelte = { "eslint_d" },
            -- python = { "ruff" }, -- ruff is also lsp so config is under lsp
            -- groovy = { "npm-groovy-lint" }, --not working, has be run under none-ls
            bash = { "shellcheck" },
        }
        local vim = vim
        local lint_augroup = vim.api.nvim_create_augroup("lint_augr", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>gl", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}

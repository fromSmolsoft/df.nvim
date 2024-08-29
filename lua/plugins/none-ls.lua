return {
    --  Possible confict with Mason lsp
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua, -- lua
                null_ls.builtins.formatting.prettier, -- angular, css, flow, graphql, html, json, jsx, javascript, less, markdown, scss, typescript, vue, yaml
                null_ls.builtins.formatting.rubocop, -- ruby
                null_ls.builtins.diagnostics.erb_lint, -- html, ruby
                null_ls.builtins.diagnostics.rubocop, -- ruby
            },
        })

        -- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}

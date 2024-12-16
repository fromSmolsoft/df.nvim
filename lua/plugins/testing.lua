return
{
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'rcasia/neotest-java',
    },
    config = function()
        local neotest = require("neotest")

        neotest.setup({
            adapters = {
                require 'neotest-java',
            },
        })

        -- keymaps
        local wk = require("which-key")
        if wk ~= nil then wk.add({ "<leader>t", group = "Testing" }) end
        local test_file = function() neotest.run.run(vim.fn.expand("%")) end
        vim.keymap.set({ "n", "v" }, "<leader>tn", neotest.run.run, { desc = "Run test nearest" })
        vim.keymap.set({ "n", "v" }, "<leader>tf", test_file, { desc = "Run tests in file" })
    end
}

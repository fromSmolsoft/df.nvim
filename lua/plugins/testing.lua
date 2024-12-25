return {
    {
        "rcasia/neotest-java",
        ft = "java",
        dependencies = {
            "mfussenegger/nvim-jdtls",
            "mfussenegger/nvim-dap",           -- for the debugger
            "rcarriga/nvim-dap-ui",            -- recommended
            "theHamsta/nvim-dap-virtual-text", -- recommended
        },
    },
    {
        'nvim-neotest/neotest',
        dependencies = {
            "nvim-neotest/nvim-nio",
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim',
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
    },


}

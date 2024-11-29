return
{
    {
        "mfussenegger/nvim-dap",
        -- debugger adapter
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },

        config = function()
            local dap = require("dap")
            local ui = require("dapui")
            local vTxt = require("nvim-dap-virtual-text")

            vTxt.setup()
            ui.setup()

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end

            vim.keymap.set('n', '<Leader>da', ui.open, { desc = "DapUi", noremap = true, })
            vim.keymap.set('n', '<Leader>db', ui.close, { desc = "close", noremap = true, })
            -- vim.keymap.set('n', '<Leader>dw', dapui.toogle, { desc = "toogle", noremap = true, })

            -- Intellij keybindings
            vim.keymap.set('n', '<F9>', dap.continue, { desc = "DAP continue", noremap = true, })
            vim.keymap.set('n', '<F8>', dap.step_over, { desc = "DAP stepover", noremap = true, })
            vim.keymap.set('n', '<F7>', dap.step_into, { desc = "DAP stepinto", noremap = true, })
            vim.keymap.set('n', '<S-F8>', dap.step_out, { desc = "DAP stepout", noremap = true, })

            -- vimkeys
            vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = "DAP continue", noremap = true, })
            vim.keymap.set('n', '<Leader>ds', dap.step_over, { desc = "DAP stepover", noremap = true, })
            vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = "DAP stepinto", noremap = true, })
            vim.keymap.set('n', '<Leader>do', dap.step_out, { desc = "DAP stepout", noremap = true, })
            vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, { desc = "Break point toogle", noremap = true, })
        end,
    },

    {
        -- python debugger
        -- requires debugpy installed
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", },
        config = function()
            -- FIX: permission denied when accessing debugpy path
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/"
            require('dap-python').setup(path)
        end
    },


    {
        "jay-babu/mason-nvim-dap.nvim",
        -- mason-nvim-dap bridges mason.nvim with the nvim-dap plugin - making it easier to use both plugins together.
        -- https://github.com/jay-babu/mason-nvim-dap.nvim
        enabled = false,
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                automatic_installation = true,
            })
        end
    },
}

return
{
    { -- debugger adapter

        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui" },
        config = function()
            local dap = require("dap")

            -- nvim-dap-ui actions called when dap takes particular action to be shown in ui eg. assining breakpoint
            local dapui = require("dapui")
            dapui.setup()
            -- require("dapui").setup()
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set('n', '<Leader>da', dapui.open, { desc = "DapUi" })
            vim.keymap.set('n', '<Leader>db', dapui.close, { desc = "close" })
            -- vim.keymap.set('n', '<Leader>dw', dapui.toogle, { desc = "toogle" })

            -- Intellij keybindings
            vim.keymap.set('n', '<F9>', dap.continue, { desc = "DAP continue" })
            vim.keymap.set('n', '<F8>', dap.step_over, { desc = "DAP stepover" })
            vim.keymap.set('n', '<F7>', dap.step_into, { desc = "DAP stepinto" })
            vim.keymap.set('n', '<S-F8>', dap.step_out, { desc = "DAP stepout" })

            -- vimkeys
            vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = "DAP continue" })
            vim.keymap.set('n', '<Leader>ds', dap.step_over, { desc = "DAP stepover" })
            vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = "DAP stepinto" })
            vim.keymap.set('n', '<Leader>do', dap.step_out, { desc = "DAP stepout" })
            vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, { desc = "Break point toogle" })
        end,
    },
    {
        -- debugger ui
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        -- config = function()
        --     local dapui = require("dapui")
        --     vim.keymap.set('n', '<Leader>dd',dapui.open(),{})
        -- end
    },
    {
        -- python debugger
        -- requires debugpy installed
        -- FIX: not working ??
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" },
        require('dap-python').setup()
    }
}

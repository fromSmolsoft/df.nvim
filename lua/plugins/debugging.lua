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
            opts = {
                -- attempt at fixing java-nvim dap
                -- registries = {
                --     'github:nvim-java/mason-registry',
                --     'github:mason-org/mason-registry',
                -- },
                ensure_installed = { "java-debug-adapter", "java-test" }
            },

        },

        config = function()
            local dap = require("dap")
            local ui = require("dapui")
            local vTxt = require("nvim-dap-virtual-text")

            vTxt.setup({ enabled = true, })

            --bash debug
            dap.adapters.bashdb = {
                type = 'executable',
                command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
                name = 'bashdb',
            }

            dap.configurations.sh = {
                {
                    type = 'bashdb',
                    request = 'launch',
                    name = "Launch file",
                    showDebugOutput = true,
                    pathBashdb = vim.fn.stdpath("data") ..
                        '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
                    pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
                    trace = true,
                    file = "${file}",
                    program = "${file}",
                    cwd = '${workspaceFolder}',
                    pathCat = "cat",
                    pathBash = "/bin/bash",
                    pathMkfifo = "mkfifo",
                    pathPkill = "pkill",
                    args = {},
                    env = {},
                    terminalKind = "integrated",
                }
            }

            -- dapui
            ui.setup()
            dap.listeners.before.attach.dapui_config = function() ui.open() end
            dap.listeners.before.launch.dapui_config = function() ui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
            dap.listeners.before.event_exited.dapui_config = function() ui.close() end

            -- keymaps
            -- add group for debugger to which-key
            require("which-key").add({ "<leader>d", group = "Debugger" })
            -- Close dap_ui and disconnect debug adapter
            local quit_debugger = function()
                ui.close()
                vim.notify("Quiting debugger")
                dap.disconnect({ terminateDebuggee = true })
            end

            vim.keymap.set('n', '<Leader>dz', ui.open, { desc = "DapUi", noremap = true, })
            vim.keymap.set('n', '<Leader>dq', quit_debugger, { desc = "Quit debugge", noremap = true, })
            -- vim.keymap.set('n', '<Leader>dw', dapui.toogle, { desc = "toogle", noremap = true, })

            -- Intellij keybindings
            vim.keymap.set('n', '<F7>', dap.step_into, { desc = "DAP stepinto", noremap = true, })
            vim.keymap.set('n', '<F8>', dap.step_over, { desc = "DAP stepover", noremap = true, })
            vim.keymap.set('n', '<S-F8>', dap.step_out, { desc = "DAP stepout", noremap = true, })
            vim.keymap.set('n', '<F9>', dap.continue, { desc = "DAP continue", noremap = true, })

            -- vimkeys
            vim.keymap.set('n', '<Leader>dc', dap.continue, { desc = "DAP continue", noremap = true, })
            vim.keymap.set('n', '<Leader>ds', dap.step_over, { desc = "DAP stepover", noremap = true, })
            vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = "DAP stepinto", noremap = true, })
            vim.keymap.set('n', '<Leader>do', dap.step_out, { desc = "DAP stepout", noremap = true, })
            vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = "Break point toogle", noremap = true, })
        end,
    },

    {
        -- python debugger
        -- requires debugpy installed
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", },
        config = function()
            -- path to .venv in root folder and debugpy must be installed there by pip install debugpy
            local path = ".venv/bin/python"
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

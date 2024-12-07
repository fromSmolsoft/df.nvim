return
{
    -- Java (jdtls) custom configuration
    'mfussenegger/nvim-jdtls',
    -- nvim-jdtls:  https://github.com/mfussenegger/nvim-jdtls
    enabled = true, -- trying out https://github.com/nvim-java/nvim-java instead and can't be used together
    dependencies = { 'hrsh7th/cmp-nvim-lsp', "mfussenegger/nvim-dap" },

    -- setup options
    opts = function()
        return {
            cmd = {
                vim.fn.expand '$HOME/.local/share/nvim/mason/bin/jdtls',
                ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar')
            },
            capabilities = require 'cmp_nvim_lsp'.default_capabilities(),
            -- bundles = { vim.fn.expand '$HOME/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar' },
            bundles = vim.split(vim.fn.glob('$HOME/.local/share/nvim/mason/packages/java-*/extension/server/*.jar', 1),
                '\n'),
            root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1] or vim.fn.getcwd()),

            -- dab (debugging)
            init_options = {
                bundles = {
                    vim.fn.glob(
                        "/home/martin/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
                        1)
                },
            },
        }
    end,

    -- setup nvim-jdtls
    config = function(_, opts)
        -- vim api auto-command to start_or_attach this only for java
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                vim.notify("Starting JDTLS...")
                local success, result = pcall(require('jdtls').start_or_attach, opts)
                if success then
                    vim.notify("JDTLS started")
                else
                    vim.notify("Error JDTLS: " .. tostring(result))
                end
            end
        })
    end
}

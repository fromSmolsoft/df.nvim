return
{
    -- java
    'mfussenegger/nvim-jdtls',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
    -- https://github.com/mfussenegger/nvim-jdtls
    enabled = false, -- trying out https://github.com/nvim-java/nvim-java instead and can't be used together

    -- setup options
    opts = function()
        return {
            cmd = {
                vim.fn.expand '$HOME/.local/share/nvim/mason/bin/jdtls',
                ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar')
            },
            capabilities = require 'cmp_nvim_lsp'.default_capabilities(),
            bundles = { vim.fn.expand '$HOME/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar' },

            root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1] or vim.fn.getcwd()),
        }
        -- TODO: configure dab (debugging)
    end,

    -- setup nvim-jdtls
    config = function(_, opts)
        -- vim api auto-command to start_or_attach this only for java
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                print("Starting JDTLS...")
                local success, result = pcall(require('jdtls').start_or_attach, opts)
                if success then
                    print("JDTLS started successfully")
                else
                    print("Error starting JDTLS: " .. tostring(result))
                end
            end
        })
    end
}

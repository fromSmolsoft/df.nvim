return
{
    -- Java (jdtls) custom configuration
    'mfussenegger/nvim-jdtls',
    -- nvim-jdtls:  https://github.com/mfussenegger/nvim-jdtls
    enabled = true, -- trying out https://github.com/nvim-java/nvim-java instead and can't be used together
    dependencies = { 'hrsh7th/cmp-nvim-lsp', "mfussenegger/nvim-dap" },

    -- setup options
    opts = function()
        local home = os.getenv("HOME")
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local pwd = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or vim.fn.getcwd())
        local project_name = vim.fn.fnamemodify(pwd, ':p:h:t')
        local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

        local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages"

        local path_to_jdtls = path_to_mason_packages .. "/jdtls"
        local path_to_jdebug = path_to_mason_packages .. "/java-debug-adapter"
        local path_to_jtest = path_to_mason_packages .. "/java-test"

        local path_to_config = path_to_jdtls .. "/config_linux"
        local lombok_path = path_to_jdtls .. "/lombok.jar"



        return {
            cmd = {
                vim.fn.expand '$HOME/.local/share/nvim/mason/bin/jdtls',
                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-Xmx1g',
                '--add-modules=ALL-SYSTEM',
                '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar'),
                -- TODO: `'-configuration'`
                '-data', workspace_dir,

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

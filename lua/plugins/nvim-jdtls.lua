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
        -- Project root & name:
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or vim.fn.getcwd())
        local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')

        -- Workspace specific cache: Class paths don't work when workspace is inside root_dir!
        local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

        -- Dynamically get paths to mason's `.../jdtls` and `.../packages` by going to `/jdtls` parent dir `/..`
        local path_to_jdtls = require("mason-registry").get_package("jdtls"):get_install_path()
        local path_to_mason_packages = vim.fn.resolve(path_to_jdtls .. "/..")

        -- Literal mason path definition:
        -- local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages" -- literal path
        -- local path_to_jdtls = path_to_mason_packages .. "/jdtls"

        local path_to_jdebug = path_to_mason_packages .. "/java-debug-adapter"
        local path_to_jtest = path_to_mason_packages .. "/java-test"

        -- Current OS:
        local os
        if vim.fn.has "macunix" then
            os = "mac"
        elseif vim.fn.has "win32" then
            os = "win"
        else
            os = "linux"
        end

        local path_to_config = path_to_jdtls .. "/config_" .. os
        local lombok_path = path_to_jdtls .. "/lombok.jar"
        local path_to_jar = path_to_jdtls .. "/org.eclipse.equinox.launcher_*.jar"

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
                "--jvm-arg=-javaagent:" .. lombok_path,
                "-jar", path_to_jar,
                '-configuration', path_to_config,
                '-data', workspace_dir,
            },

            capabilities = require 'cmp_nvim_lsp'.default_capabilities(),
            bundles = vim.split(vim.fn.glob('$HOME/.local/share/nvim/mason/packages/java-*/extension/server/*.jar', 1),
                '\n'),
            root_dir = root_dir,
            settings = {
                java = {
                    references = {
                        includeDecompiledSources = true,
                    },
                    format = {
                        enabled = true,
                        settings = {
                            url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
                            profile = "GoogleStyle",
                        },
                    },
                    eclipse = {
                        downloadSources = true,
                    },
                    maven = {
                        downloadSources = true,
                    },
                    signatureHelp = { enabled = true },
                    contentProvider = { preferred = "fernflower" },

                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    completion = {
                        favoriteStaticMembers = {
                            "org.hamcrest.MatcherAssert.assertThat",
                            "org.hamcrest.Matchers.*",
                            "org.hamcrest.CoreMatchers.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                            "org.mockito.Mockito.*",
                        },
                        filteredTypes = {
                            "com.sun.*",
                            "io.micrometer.shaded.*",
                            "java.awt.*",
                            "jdk.*",
                            "sun.*",
                        },
                        importOrder = {
                            "java",
                            "javax",
                            "com",
                            "org",
                        },
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            -- flags = {
                            -- 	allow_incremental_sync = true,
                            -- },
                        },
                        useBlocks = true,
                    },
                    configuration = {
                        runtimes = {
                            -- Arch Linux official openJDKs paths:
                            --    Requires: to install JDK manually
                            --    eg.: `pacman -S extra/jdk17-openjdk extra/jdk21-openjdk extra/jdk23-openjdk`
                            {
                                name = "Java21-arch",
                                path = "/usr/lib/jvm/java-21-openjdk/bin/",
                            },
                            {
                                name = "Java23-arch",
                                path = "/usr/lib/jvm/java-23-openjdk/bin/",
                            },
                            {
                                name = "Java17-arch",
                                path = "/usr/lib/jvm/java-17-openjdk/bin/",
                            },
                        }
                    },
                }
            },

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

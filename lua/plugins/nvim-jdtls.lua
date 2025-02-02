local function print_table(t)
    local message = ""
    for _, value in ipairs(t) do
        message = message .. value .. " "
    end
    vim.notify(message, vim.log.levels.INFO)
end

local function get_os()
    local os_name = vim.fn.has("macunix") == 1 and "mac" or
        vim.fn.has("win32") == 1 and "win" or
        "linux"

    -- Debug information
    vim.notify(string.format("Detected OS: %s", os_name))
    -- vim.notify(string.format("macunix: %s", vim.fn.has("macunix") == 1 and "true" or "false"))
    -- vim.notify(string.format("win32: %s", vim.fn.has("win32") == 1 and "true" or "false"))

    return os_name
end

return
{
    -- https://github.com/mfussenegger/nvim-jdtls
    "mfussenegger/nvim-jdtls",
    cond = true, -- don't use together with "nvim-java/nvim-java" or "lsp-config"'s jdtls
    opts = function()
        local home = os.getenv("HOME")
        -- Project
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or vim.fn.getcwd())
        local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')

        local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name
        -- Workspace cache: Class paths don't work when workspace is in project's root_dir!

        local path_to_jdtls = require("mason-registry").get_package("jdtls"):get_install_path()
        local path_to_mason_packages = vim.fn.resolve(path_to_jdtls .. "/..")
        -- Mason

        -- Literal mason path definition:
        -- local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages" -- literal path
        -- local path_to_jdtls = path_to_mason_packages .. "/jdtls"
        local os = get_os()

        local path_to_jdebug = path_to_mason_packages .. "/java-debug-adapter"
        local path_to_jtest = path_to_mason_packages .. "/java-test"
        -- Jdtls features
        -- Capabilities
        -- java-debug and java-test extensions

        end

        local path_to_config = path_to_jdtls .. "/config_" .. os
        local lombok_path = path_to_jdtls .. "/lombok.jar"
        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

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
                -- Command + flags launching jdtls
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

            init_options = {
                bundles = {
                    vim.fn.glob(
                        "/home/martin/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
                        1)
                },
            },
        }

            -- type :CheckJavaVersion to check java version
            vim.api.nvim_create_user_command(
                'CheckJavaVersion',
                function()
                    vim.notify(vim.fn.system('/usr/bin/java --version'))
                end,
                {}
            )
    end,

    -- setup nvim-jdtls
    config = function(_, opts)
        -- vim api auto-command to start_or_attach this only for java
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                vim.notify("Starting JDTLS with: `require('jdtls').start_or_attach`", vim.log.levels.INFO)
                local success, result = pcall(require("jdtls").start_or_attach, opts)
                if success then
                    vim.notify("JDTLS started: " .. tostring(result), vim.log.levels.INFO)
                else
                    vim.notify("JDTLS [ERROR]: " .. tostring(result), vim.log.levels.ERROR)
                end
            end
        })
    end
}

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
    return os_name
end

local debug_list = { "[DEBUG]\n" }

local function merge_tables(t1, t2)
    table.move(t2, 1, #t2, #t1 + 1, t1)
    return t1
end

local function add_to_debug_list(t)
    merge_tables(debug_list, t)
end

return
{
    -- FIXME: jdtls exits with code 13
    -- https://github.com/mfussenegger/nvim-jdtls
    "mfussenegger/nvim-jdtls",
    cond = true, -- don't use together with "nvim-java/nvim-java" or "lsp-config"'s jdtls
    opts = function()
        -- Project
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or vim.fn.getcwd())
        local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')

        -- Workspace cache: Class paths don't work when workspace is in project's root_dir!
        local user_home = os.getenv("HOME")
        local workspace_path = user_home .. "/.cache/jdtls/workspace/" .. project_name

        -- Mason
        local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
        local jdtls_path = require("mason-registry").get_package("jdtls"):get_install_path()

        local os = get_os()

        -- Jdtls features
        local path_to_config = jdtls_path .. "/config_" .. os
        local lombok_path = jdtls_path .. "/lombok.jar"
        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

        -- Capabilities
        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
        extendedClientCapabilities.onCompletionItemSelectedCommand = "editor.action.triggerParameterHints"
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        -- java-debug and java-test extensions
        local bundles = { vim.split(
            vim.fn.glob(mason_path .. "packages/java-*/extension/server/*.jar", 1), '\n'), }

        local cmd = {
            vim.fn.expand "$HOME/.local/share/nvim/mason/bin/jdtls",
            -- "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1G",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            "--jvm-arg=-javaagent:" .. lombok_path,
            "-jar", launcher,
            "-configuration", path_to_config,
            "-data", workspace_path,
        }

        -- Debugging
        add_to_debug_list({
            "\nDetected OS= ", os,
            "\nproject_name= ", project_name,
            "\nroot_dir=", root_dir,
            "\ncmd={\n" })
        add_to_debug_list(cmd)
        add_to_debug_list({ "\n}\n" })

        return {
                cmd = cmd,
                capabilities = lsp_capabilities,
                root_dir = root_dir,
                settings = {
                    java = {
                        debug = {
                            enableDebugRequests = true,
                            jvmArgs = {
                                "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:1044"
                            },
                            -- vim.lsp.set_log_level("TRACE"),
                        },
                        references = { includeDecompiledSources = true, },
                        format = {
                            enabled = true,
                            settings = {
                                url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
                                profile = "GoogleStyle",
                            },
                        },
                        eclipse = { downloadSources = true, },
                        maven = { downloadSources = true, },
                        extendedClientCapabilities = extendedClientCapabilities,
                        inlineHints = { pameterNames = { enabled = "all" } },
                        signatureHelp = { enabled = true },
                        contentProvider = { preferred = "fernflower" },
                        sources = {
                            organizeImports = {
                                -- when to group imports `*`
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
                                "com.sun.*", "io.micrometer.shaded.*",
                                "java.awt.*", "jdk.*", "sun.*",
                            },
                            importOrder = { "java", "javax", "com", "org", },
                        },
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                                -- flags = { allow_incremental_sync = true, },
                            },
                            useBlocks = true,
                        },
                        configuration = {
                            runtimes = {
                                -- Arch Linux official openJDKs specific paths.
                                {
                                    name = "Java23-arch",
                                    path = "/usr/lib/jvm/java-23-openjdk/bin/",
                                    default = true
                                },
                                {
                                    name = "Java21-arch",
                                    path = "/usr/lib/jvm/java-21-openjdk/bin/",
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
                    bundles = bundles,
                    bundles = {},
                },
            },

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
                print_table(debug_list)
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

local TAG = "[JDTLS]"
local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local tbltostring = require("utils.print_table")
local vutil = require("utils.vutil")

return
{
    -- FIXME: jdtls exits with code 13
    -- https://github.com/mfussenegger/nvim-jdtls
    "mfussenegger/nvim-jdtls",
    dependencies = { "williamboman/mason.nvim" --[[ need for mason data]], },
    cond = true, -- don't use together with "nvim-java/nvim-java" or "lsp-config"'s jdtls
    opts = function()
        -- Project
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or vim.fn.getcwd())
        local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')

        -- Workspace cache: Class paths don't work when workspace is in project's root_dir!
        local user_home = vutil.get_userhome()
        local workspace_path = user_home .. "/.cache/jdtls/workspace/" .. project_name

        -- Mason
        local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
        local jdtls_path = require("mason-registry").get_package("jdtls"):get_install_path()

        local os = vutil.get_os()

        -- Jdtls features
        local path_to_config = jdtls_path .. "/config_" .. os
        local lombok_path = jdtls_path .. "/lombok.jar"
        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

        --[[
        INFO: This snippet checks if launcher filename includes _ and version, otherwise filename without _version is used.
        `org.eclipse.launcher_*.jar` -> `org.eclipse.launcher.jar`
        [Reason] Mason jdtls package had version stripped from filename.
        --]]
        if not vutil.is_file(launcher) then
            local launcher_dmsg = "\tlauncher = \"" .. launcher .. "\""
            vim.notify(TAG .. "Path to is invalid.\n " .. launcher_dmsg .. " \n" .. "Trying alternative file name:",
                vim.log.levels.ERROR)
            launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher.jar")
            launcher_dmsg = "launcher= \"" .. launcher .. "\""
            if not vutil.is_file(launcher) then
                vim.notify(TAG .. "Path to is invalid. " .. launcher_dmsg, vim.log.levels.ERROR)
            else
                vim.notify(TAG .. "success.\n " .. launcher_dmsg)
            end
        end

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

        return {
                cmd = cmd,
                capabilities = lsp_capabilities,
                root_dir = root_dir,
                settings = {
                    java = {
                        -- debug = {
                        --     enableDebugRequests = true,
                        --     jvmArgs = {
                        --         "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:1044"
                        --     },
                        --     vim.lsp.set_log_level("TRACE"),
                        -- },
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
                                -- when to group imports to `*`
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
                                "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*",
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
                                    -- default = true
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

                init_options = { bundles = bundles, },
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
        -- [DEBUG] dump all of the opts to console
        -- vim.notify(tbltostring.dump(opts))

        -- vim auto-command calls start_or_attach this only for java
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            group = java_cmds,
            desc = TAG .. " start_or_attach",
            callback = function()
                vim.notify("[JDTLS]: start_or_attach", vim.log.levels.INFO)
                local success, result = pcall(require("jdtls").start_or_attach, opts)
                if success then
                    vim.notify(TAG .. " started: " .. tostring(result), vim.log.levels.INFO)
                else
                    vim.notify(TAG .. " [ERROR]: " .. tostring(result), vim.log.levels.ERROR)
                end
            end
        })
    end
}

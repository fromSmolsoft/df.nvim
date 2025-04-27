local TAG = "[JDTLS]"

---"imports"
local vim = vim
local java_augr = vim.api.nvim_create_augroup('java_augr', { clear = true })
local tbl = require("utils.print_table")
local vutil = require("utils.vutil")
local mason_registry = require("mason-registry")
local mason_core_package = require("mason-core.package")

---Install mason package if not already installed
---@param package_name string name of the mason package same as in `:MasonInstall package`
local function install_or_skip(package_name)
    if (mason_registry.is_installed(package_name)) then return end
    mason_registry.refresh()
    -- mason_core_package.install(package_name) -- TODO: use API for installing packages
    vim.cmd { cmd = "MasonInstall", args = { package_name } }
end

return { {
    -- https://github.com/mfussenegger/nvim-jdtls
    "mfussenegger/nvim-jdtls",
    dependencies = { "williamboman/mason.nvim" --[[ need for mason data]], },
    cond = true, -- don't use together with "nvim-java/nvim-java" or "lsp-config"'s jdtls
    ---@return table jdtls_configuration
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
        install_or_skip("jdtls") -- INFO:Mason has bug -> prevents installing versions eg. `jdtls@1.43.0`
        local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

        -- path to java 21+ / jdtls executable
        local java = jdtls_path .. "/jdtls"

        -- local operation system
        local os = vutil.get_os()

        -- Jdtls features
        local path_to_config = jdtls_path .. "/config_" .. os
        local lombok_path = jdtls_path .. "/lombok.jar"
        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

        --  if launcher filename doesn't include a version try `org.eclipse.launcher_*.jar` -> `org.eclipse.launcher.jar`. (Mason may ship jdtls without a version).
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
        install_or_skip("java-debug-adapter")
        install_or_skip("java-test")
        local bundles = vim.split(vim.fn.glob(mason_path .. "packages/java-*/extension/server/*.jar", 1),
            '\n')
        -- Filter out unwanted bundles
        local ignored_bundles = { "com.microsoft.java.test.runner-jar-with-dependencies.jar", "jacocoagent.jar" }
        local find = string.find
        local function should_ignore_bundle(bundle)
            for _, ignored in ipairs(ignored_bundles) do
                if find(bundle, ignored, 1, true) then
                    return true
                end
            end
        end
        bundles = vim.tbl_filter(function(bundle) return bundle ~= "" and not should_ignore_bundle(bundle) end,
            bundles)

        -- Command to start jdtls
        local cmd = {
            java,
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
                function() vim.notify(vim.fn.system('/usr/bin/java --version')) end,
                {}
            )
    end,

    -- setup nvim-jdtls
    config = function(_, opts)
        -- [DEBUG] dump all of the opts to console
        -- vim.notify(TAG .. "\n" .. tbl.dump(opts))

        -- vim auto-command calls start_or_attach this only for java
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            group = java_augr,
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
}, {
    -- https://github.com/elmcgill/springboot-nvim,
    -- enable devtools to auto reload running app upon code change among other things
    "elmcgill/springboot-nvim",
    cond = false,
    -- ft = "Java",
    -- event = "VeryLazy",
    opts = function()
        -- extras
        require("which-key").add({ "<leader>J", desc = "Java" })
        local springboot_nvim = require("springboot-nvim")

        vim.keymap.set('n', '<leader>Jr', springboot_nvim.boot_run, { desc = "[J]ava SpringBoot [R]un" })
        vim.keymap.set('n', '<leader>Jc', springboot_nvim.generate_class, { desc = "[J]ava Create [C]lass" })
        vim.keymap.set('n', '<leader>Ji', springboot_nvim.generate_interface, { desc = "[J]ava Create [I]nterface" })
        vim.keymap.set('n', '<leader>Je', springboot_nvim.generate_enum, { desc = "[J]ava Create [E]num" })

        -- "springboot-nvim" config
        return {}
    end
},

    {
        -- java refactoring extensions, https://github.com/simaxme/java.nvim,
        'simaxme/java.nvim',
        opts = {
            rename = {
                enable = true,  -- enable the functionality for renaming java files
                nvimtree = true, -- enable nvimtree integration
                write_and_close = false -- automatically write and close modified (previously unopened) files after refactoring a java file
            },
            snippets = {
                enable = true -- enable the functionality for java snippets
            },
            root_markers = { -- markers for detecting the package path (the package path should start *after* the marker)
                "main/java/",
                "test/java/"
            }
        }
    }

}

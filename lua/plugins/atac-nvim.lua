return
{
    -- REST requests without leaving neovim similar to postman, https://github.com/NachoNievaG/atac.nvim, requires atac >= 0.13.0
    "NachoNievaG/atac.nvim",
    cond = vim.fn.has("nvim-0.9") == 1, -- enable only for nvim version >= 0.9
    dependencies = { "akinsho/toggleterm.nvim" },
    opts = function()
        -- TODO: store project specific files in `project_root/.tmp/atac/`
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or vim.fn.getcwd())
        vim.notify("root_dir= \"" .. root_dir .. "\"")

        return {
            dir = vim.fn.resolve(root_dir .. "/.atac"), -- By default, the dir will be set as /tmp/atac
        }
    end
}

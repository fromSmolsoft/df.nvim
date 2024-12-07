return
{
    -- REST requests without leaving neovim similar to postman, https://github.com/NachoNievaG/atac.nvim, requires atac >= 0.13.0
    "NachoNievaG/atac.nvim",
    enabled = false,
    dependencies = { "akinsho/toggleterm.nvim" },
    opts = {
        -- TODO: store project specific files in `project_root/.tmp/atac/`
        -- dir = vim.fn.resolve(cwd .. "/.atac"), -- By default, the dir will be set as /tmp/atac
    },
}

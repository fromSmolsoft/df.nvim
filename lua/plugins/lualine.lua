-- return string of LSP clients attached to current buffer
local clients_lsp = function()
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return ' '
    end

    local c = {}
    for _, client in pairs(clients) do
        -- FIX: trows error `illegal character < >` at "random", when run together with jdtls-nvim on java project

        -- replace non-alphanumerical characters
        local lspName = string.gsub(client.name, "%W", "_")

        -- trim whitespaces
        lspName = lspName:match '^()%s*$' and '' or lspName:match '^%s*(.*%S)'
        table.insert(c, lspName)
    end
    -- return '\u{f085} ' .. table.concat(c, ',')
    return 'lsp:' .. table.concat(c, '|')
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "arkav/lualine-lsp-progress",
    },

    config = function()
        -- code
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                -- lualine_c = { "filename", "lsp_progress"},
                lualine_c = { "filename", "lsp_progress", clients_lsp },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}

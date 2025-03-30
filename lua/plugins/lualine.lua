-- Helper, returns string of LSP clients attached to current buffer
local function clients_lsp()
    -- FIX: when jdtls client gets loaded it trows error illegal char < >
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return ""
    end

    local c = {}
    for _, client in pairs(clients) do
        local lspName = client.name

        -- replace non-alphanumerical characters
        -- local lspName = string.gsub(client.name, "%W", "_")

        -- trim whitespaces
        -- lspName = lspName:match '^()%s*$' and '' or lspName:match '^%s*(.*%S)'

        -- Attempt at fixing jdtls' client name occasionally including illegal char < >
        if string.find(lspName, "jdtls") then lspName = "jdtls" end
        table.insert(c, lspName)
    end
    return '\u{f085}_' .. table.concat(c, '|')
end

return
{
    "nvim-lualine/lualine.nvim",
    enabled = true,
    dependencies = {
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
                -- lualine_c = { "filename", clients_lsp, "lsp_progress" },
                lualine_c = { { "filename", path = 1, } },
                lualine_x = {},
                lualine_y = { "encoding", "fileformat", "filetype" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1, } },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            extensions = {
                -- package manger
                "lazy",
                "mason",

                -- file explorer
                "fzf",
                "neo-tree",
                "oil",

                -- development
                "fugitive",
                "nvim-dap-ui",
                "trouble",
                "man",
            },
        })
    end,
}

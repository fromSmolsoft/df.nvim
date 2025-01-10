return
{
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    -- TODO: set which-key group
    -- config = function()
    --     -- which-key create key group
    --     local wk = require("which-key")
    --     if wk ~= nil then wk.add({ "<leader>x", group = "Diagnostics" }) end
    -- end,
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        -- {
        --     "<leader>cs",
        --     "<cmd>Trouble symbols toggle focus=false<cr>",
        --     desc = "Symbols (Trouble)",
        -- },
        -- {
        --     "<leader>cl",
        --     "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        --     desc = "LSP Definitions / references / ... (Trouble)",
        -- },
        -- {
        --     "<leader>xL",
        --     "<cmd>Trouble loclist toggle<cr>",
        --     desc = "Location List (Trouble)",
        -- },
        -- {
        --     "<leader>xQ",
        --     "<cmd>Trouble qflist toggle<cr>",
        --     desc = "Quickfix List (Trouble)",
        -- },
    },
}

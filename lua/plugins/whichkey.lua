--- require "which-key"
local wk = require("which-key");

--- add custom groups to which_key
local addGrp = function()
    wk.add({ "<leader>b", desc = "Buffers" })
    wk.add({ "<leader>x", desc = "Troubles" })
    wk.add({ "<leader>u", desc = "UMLs" })
    wk.add({ "<leader>s", desc = "Sessions" })
end

return {
    "folke/which-key.nvim",
    -- TODO: show F1..F12 keys if mapped
    -- TODO: describe groups
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it e
        -- mpty to use the default settings
        -- referto the configuration section below

        addGrp()
    },
    keys = {
        { "<leader>?", function() wk.show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)", },
    },
}

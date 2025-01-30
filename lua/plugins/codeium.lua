local l_loaded = false;
--- Helper function as a toggle plugin.
local enable_codeium = function()
    if l_loaded then
        l_loaded = not l_loaded
        vim.notify("Codeium enabled=" .. tostring(l_loaded))
    else
        -- FIXME: unload / disable plugin "on the go"
        l_loaded = not l_loaded
        vim.notify("TODO: not implemeneted" .. "Codeium enabled=" .. tostring(l_loaded))
    end
end;
return {
    --- Codeium ai assistant
    "Exafunction/codeium.nvim", -- https://github.com/Exafunction/codeium.nvim
    keys = { { "<leader>cac", enable_codeium, desc = "Codeium: enabled" }, },
    -- event = "VeryLazy",
    -- cond = l_loaded,
    -- FIXME: inline hints  not working
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},

    -- config = function()
    --     require("codeium").setup({})
    -- end,
}

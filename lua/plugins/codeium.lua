return {
    "Exafunction/codeium.nvim", -- https://github.com/Exafunction/codeium.nvim
    event = "VeryLazy",
    enabled = true,
    -- FIXME: inline hints / autocompletion not working
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

return {
    "Exafunction/codeium.nvim", -- https://github.com/Exafunction/codeium.nvim
    event = "VeryLazy",
    enabled = false,
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

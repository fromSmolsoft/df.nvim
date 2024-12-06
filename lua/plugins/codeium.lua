return {
    -- todo: fix
    "Exafunction/codeium.nvim",

    -- enable / disable plugin
    enabled = true,

    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {},

    config = function()
        require("codeium").setup({})
    end,
}

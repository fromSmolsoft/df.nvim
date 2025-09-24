return {
    --- Autoclose and autorename html tags, https://github.com/windwp/nvim-ts-autotag
    --- requires treesitter
    "windwp/nvim-ts-autotag",
    opts = {},
    event = { "BufReadPre", "BufNewFile" }
}

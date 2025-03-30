return {
    -- automatically highlighting other uses of the word under the cursor, https://github.com/RRethy/vim-illuminate
    "RRethy/vim-illuminate",
    configure = {
        providers = {
            'lsp',
            'treesitter',
            'regex',
        },
        delay = 400,
        filetypes_denylist = {
            'dirbuf',
            'dirvish',
            'fugitive',
        },
    },

}

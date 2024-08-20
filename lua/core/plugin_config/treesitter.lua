require'nvim-treesitter.configs'.setup{
  -- A list of parser names, or "all"
  ensure_installed = {"java", "lua", "vim", "c", "javascript"},

  -- Install parsers synchronously (only applied to 'ensure installed'
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  }

}

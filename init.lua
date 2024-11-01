local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto install lazy.nvim plugin manager
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- load custom config(s)
require("keymaps")
require("options")

-- load lazy.nvim and pass in plugins dir to autoload all plugins
require("lazy").setup("plugins")

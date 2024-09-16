
-- DRY: Local variable for `vim.opt`, `vim.cmd`, etc. 
--  so it doesn't have to be repeated everytime

local opt  = vim.opt
local cmd  = vim.cmd

-- copy/paste
opt.clipboard="unnamed,unnamedplus"

-- color scheme (terminal colors required!)
opt.termguicolors = true

-- cmd.colorscheme('tokyonight')
-- cmd.colorscheme('darcula')

opt.number = true
opt.relativenumber = true
opt.scrolloff = 5
-- backspace
opt.backspace = '2'

opt.showcmd = true
opt.laststatus = 2
opt.autowrite = true
opt.cursorline = true
opt.autoread = true

-- use spaces for tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true

-- spellcheck
opt.spelllang = {'en_us', 'en_gb', 'cs'}
opt.spell = true



local vkey = vim.keymap

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- navigate between panes by ctrl + [hjkl]
vkey.set('n', '<leader>h', ':nohlsearch<CR>')
vkey.set('n', '<c-h>', ':wincmd h<CR>')
vkey.set('n', '<c-j>', ':wincmd j<CR>')
vkey.set('n', '<c-k>', ':wincmd k<CR>')
vkey.set('n', '<c-l>', ':wincmd l<CR>')

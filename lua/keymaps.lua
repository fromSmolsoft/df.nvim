local vkey = vim.keymap

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- navigate between panes by ctrl + [hjkl]
vkey.set('n', '<leader>h', ':nohlsearch<CR>')
vkey.set('n', '<c-h>', ':wincmd h<CR>', { desc = "Go to left pane" })
vkey.set('n', '<c-j>', ':wincmd j<CR>', { desc = "Go to bottom pane" })
vkey.set('n', '<c-k>', ':wincmd k<CR>', { desc = "Go to top pane" })
vkey.set('n', '<c-l>', ':wincmd l<CR>', { desc = "Go to right pane" })

vkey.set('n', '<leader>bd', ':%bd|e#<CR>', { desc = "Close saved buffers" })
vkey.set('n', '<leader>*', '*#:%s///gc<left><left><left>', { desc = "Search & replace" })

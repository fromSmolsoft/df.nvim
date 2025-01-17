local vkey = vim.keymap

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- navigate between panes by ctrl + [hjkl]
vkey.set('n', '<c-h>', ':wincmd h<CR>', { desc = "← left pane" })
vkey.set('n', '<c-j>', ':wincmd j<CR>', { desc = "↓ bottom pane" })
vkey.set('n', '<c-k>', ':wincmd k<CR>', { desc = "↑ upper pane" })
vkey.set('n', '<c-l>', ':wincmd l<CR>', { desc = "→ right pane" })

-- splits
vkey.set('n', '<leader>z', ':tabedit %<CR>', { desc = "Max active split in a new tab" })
vkey.set('n', '<leader>co', ':windo diffthis<CR>', { desc = "Diff splits" })
vkey.set('n', '<leader>cx', ':windo diffoff<CR>', { desc = "Diff off" })

-- buffers
vkey.set('n', '<leader>bd', ':%bd|e#<CR>', { desc = "Close saved buffers" })
vkey.set('n', '<leader>bp', ':buffer#<CR>', { desc = "↹ Previous buffer" })
vkey.set('n', '<leader><Tab>', ':buffer#<CR>', { desc = "↹ Previous buffer" })
--
-- searches
vkey.set('n', '<leader>h', ':nohlsearch<CR>')
vkey.set('n', '<leader>*', '*#:%s///gc<left><left><left>', { desc = "Search & replace" })

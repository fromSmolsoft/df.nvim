

-- return the path to Neovim's data folder regardless of OS.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- ================================ 
-- Lazy.vnim 
-- --------------------------------

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

-- Plugins to be lodaded by the 'lazy', a plugin manager
require('lazy').setup({

  -- List of plugins:  

  --color scheme(s)
  {'folke/tokyonight.nvim',
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme tokyonight]])
	end
  },
  {'doums/darcula'},

  -- status bar / line 
  {'nvim-lualine/lualine.nvim'},

  -- navigation (files,...)
  {'nvim-tree/nvim-tree.lua'},
  {'nvim-tree/nvim-web-devicons'},
  {'nvim-telescope/telescope.nvim'},

  -- VCS
  {'mhinz/vim-signify'},

  -- syntax highlight
  {'nvim-treesitter/nvim-treesitter'},

  -- lsp
  {"williamboman/mason.nvim"}, -- manage external LSP servers, DAP servers, linters, and formatters
  {"williamboman/mason-lspconfig.nvim"},
  {"neovim/nvim-lspconfig"},

  {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},

  -- Autocompletion
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},

  -- Autocompletion - snippets
{
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp"
},

  {"saadparwaiz1/cmp_luasnip"},
  {"rafamadriz/friendly-snippets"},

-- Autocompletion - AI / LLM
{
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
        })
    end
},


})



---
-- lsp zero config
--- 
local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})


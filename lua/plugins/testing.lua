return
{
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
        'rcasia/neotest-java',
    },

    config = function()
        require 'neotest'.setup({
            adapters = {
                require 'neotest-java',
            },
        })
    end
}

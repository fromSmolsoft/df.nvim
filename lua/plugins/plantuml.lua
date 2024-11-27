return
{
    {
        -- run plant uml in bash with currently open file , no need to save it first
        vim.keymap.set("n", "<leader>us", ":!plantuml % -svg<CR>", { desc = "Puml->svg" })
    },
    {
        -- Install markdown preview, use npx if available.
        "iamcco/markdown-preview.nvim",
        enabled = false, --doesn't work, probably unmaintained
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function(plugin)
            if vim.fn.executable "npx" then
                vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
            else
                vim.cmd [[Lazy load markdown-preview.nvim]]
                vim.fn["mkdp#util#install"]()
            end
        end,
        init = function()
            if vim.fn.executable "npx" then vim.g.mkdp_filetypes = { "markdown" } end
        end,
    },

    {
        -- using my own fork for a time being
        -- 'javiorfo/nvim-soil',
        'fromSmolsoft/nvim-soil',
        branch = "unfreeze",

        -- Optional for puml syntax highlighting:
        dependencies = { 'javiorfo/nvim-nyctophilia' },

        lazy = true,
        ft = "plantuml",
        opts = {
            -- If you want to change default configurations

            -- If you want to use Plant UML jar version instead of the install version
            -- puml_jar = "/path/to/plantuml.jar",

            -- If you want to customize the image showed when running this plugin
            image = {
                darkmode = true, -- Enable or disable darkmode
                format = "svg",  -- Choose between png or svg

                -- This is a default implementation of using nsxiv to open the resultant image
                -- Edit the string to use your preferred app to open the image (as if it were a command line)
                -- Some examples:
                -- return "feh " .. img
                -- return "xdg-open " .. img
                execute_to_open = function(img)
                    return "nsxiv -b " .. img
                end
            }
        },
        config = function(_, opts)
            require("soil").setup(opts)
        end,

        vim.keymap.set("n", "<leader>ur", ":Soil", { desc = "Puml->img & open" })
    }


    -- {
    --     'bryangrimes/plantuml.nvim',
    --     version = '*',
    --     config = function()
    --         require('plantuml').setup({
    --             renderer = {
    --                 type = 'text',
    --                 options = {
    --                     split_cmd = 'vsplit', -- Allowed values: 'split', 'vsplit'.
    --                 }
    --             },
    --             render_on_write = true, -- Set to false to disable auto-rendering.
    --         })
    --     end,
    -- }
}

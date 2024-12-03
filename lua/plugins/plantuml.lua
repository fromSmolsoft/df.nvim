return
{
    {
        -- TODO: activate shortcuts only for plantuml file type
        -- config = function()
        --     vim.api.nvim_create_autocmd("FileType", {
        --         pattern = "plantuml",
        --         callback = function()
        -- run plant uml in bash with currently open file , no need to save it first
        vim.keymap.set("n", "<leader>us", ":!plantuml % -svg<CR>", { desc = "Puml->svg" }),
        vim.keymap.set("n", "<leader>up", ":!plantuml % -png<CR>", { desc = "Puml->png" }),
        vim.keymap.set("n", "<leader>ud", ":!plantuml % -dpng<CR>", { desc = "Puml->dpng" }),
        --         end
        --     })
        -- end
    },
    {
        'javiorfo/nvim-soil',
        -- my own fork that fixes freezing
        -- 'fromSmolsoft/nvim-soil',
        -- branch = "unfreeze",

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
                -- darkmode = true, -- Enable or disable darkmode
                darkmode = false, -- Enable or disable darkmode
                -- format = "svg",   -- Choose between png or svg
                format = "png",   -- Choose between png or svg

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
}

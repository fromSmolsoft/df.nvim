return
{

    --- plantuml suntaxt highlighting ---
    {
        -- puml syntax (vim script plugin). https://github.com/aklt/plantuml-syntax
        "aklt/plantuml-syntax",
        ft = { "plantuml", "puml", "pu", "uml", "iuml" },
        -- enabled = false,
    },


    --- plantuml previewers ---
    {
        "https://gitlab.com/itaranto/preview.nvim",
        even = "VeryLazy",
        ft = { "plantuml", },
        version = "*",
        opts = {
            -- Your options.
            previewers_by_ft = {
                plantuml = {
                    name = "plantuml_svg",
                    renderer = {
                        type = "command",
                        opts = {
                            cmd = { "feh", "--auto-zoom", "--scale-down", "--borderless" },
                        }
                    },

                    --  FIXME: trows error bc plantuml doesn"t support ascii rendering for all diagram types
                    -- plantuml = { name = "plantuml_text", renderer = { type = "buffer", opts = { split_cmd = "split" } }, },

                    -- markdown = { name = "pandoc_wkhtmltopdf", renderer = { type = "command", opts = { cmd = { "zathura" } } }, },
                },
            },
            previewers = {
                plantuml_svg = {
                    -- args = { "-pipe", "-tpng" },
                },
            },
            render_on_write = true,
        }
    },
    {
        -- TODO: activate shortcuts only for plantuml file type
        -- config = function()
        --     vim.api.nvim_create_autocmd("FileType", {
        --         pattern = "plantuml",
        --         callback = function()
        vim.keymap.set("n", "<leader>up", ":!plantuml % -png<CR>", { desc = "Puml->png" }),
        vim.keymap.set("n", "<leader>ud", ":!plantuml % -dpng<CR>", { desc = "Puml->dpng" }),
        --         end
        --     })
        -- end
    },
    {
        "javiorfo/nvim-soil",
        -- my own fork that fixes freezing
        -- "fromSmolsoft/nvim-soil",
        -- branch = "unfreeze",
        ft = "plantuml",
        -- Optional for puml syntax highlighting:
        -- dependencies = { "javiorfo/nvim-nyctophilia", "folke/which-key.nvim" },
        -- lazy = true,
        opts = function()
            -- If you want to use Plant UML jar version instead of the install version
            -- puml_jar = "/path/to/plantuml.jar",

            -- If you want to customize the image showed when running this plugin
            image = {
                    darkmode = false, -- Enable or disable darkmode
                    format = "png",   -- Choose between png or svg (svg has white background)

                    -- This is a default implementation of using nsxiv to open the resultant image
                    -- Edit the string to use your preferred app to open the image (as if it were a command line)
                    -- Some examples:
                    -- return "feh " .. img
                    -- return "xdg-open " .. img
                    execute_to_open = function(img)
                        return "nsxiv -b " .. img
                    end,
                },
                require("which-key").add({ "<leader>u", group = "UML" }),
                vim.keymap.set("n", "<leader>ur", ":Soil", { desc = "Puml->img & open" })
        end

    }
}

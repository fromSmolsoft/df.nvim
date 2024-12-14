return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        -- vertical = { width = 0.9, height = 0,95 },
                    }
                },
                extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown({}), },
                },
            })


            -- Keymaping

            require("which-key").add({ "<leader>f", group = "Find" })

            local builtin = require("telescope.builtin")

            -- Find
            vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find file" })
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find file" })
            vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find command" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffer" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find in files" })
            vim.keymap.set("n", "<leader><leader>", ":Telescope oldfiles cwd_only=true<CR>", { desc = "Find oldFile" })
            vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles cwd_only=true<CR>", { desc = "Find oldFile" })

            -- Git
            vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
            vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git diff" })
            vim.keymap.set("n", "<leader>gb", builtin.git_stash, { desc = "Git stash" })
            require("telescope").load_extension("ui-select")
        end,
    },
}

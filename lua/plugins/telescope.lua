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
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")

    -- Find
      vim.keymap.set("n", "<C-p>", builtin.find_files, {desc ="Find files"})
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {desc ="Find files"})
      vim.keymap.set("n", "<leader>fc", builtin.commands, {desc ="Find cmd"})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {desc ="Find buffers"})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find in files"})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Find oldFiles"})

    -- Git
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits"})
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git diff"})
      vim.keymap.set("n", "<leader>gb", builtin.git_stash, { desc = "Git stash"})
      require("telescope").load_extension("ui-select")
    end,
  },
}

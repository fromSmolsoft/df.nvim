return {
  {
    -- requires [grip-grab](https://github.com/alexpasmantier/grip-grab) which has to be installed by cargo
        -- disabling for now until it supports `rg`
    "alexpasmantier/pymple.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional (nicer ui)
      "stevearc/dressing.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    build = ":PympleBuild",
    config = function()
      require("pymple").setup()
    end,
  },
}

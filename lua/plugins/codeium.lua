return {
	-- todo: fix
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	cmd = "Codeium",
	build = ":Codeium Auth",
	opts = {},

	config = function()
		require("codeium").setup({})
	end,
}

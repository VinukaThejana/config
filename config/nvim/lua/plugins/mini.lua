return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		recommended = true,
		config = function()
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},
}

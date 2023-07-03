--[[ General utilities ]]

return {
	"nvim-lua/plenary.nvim",
	"lewis6991/impatient.nvim",

	"mbbill/undotree",
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	"norcalli/nvim-colorizer.lua",

	"tpope/vim-surround",
	"tpope/vim-repeat",

	"milisims/nvim-luaref",

	"lukas-reineke/indent-blankline.nvim",

	"nvim-orgmode/orgmode",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
	}
}

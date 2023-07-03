--[[ LSPs and Daps ]]

return {
	-- LSPs

	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	"WhoIsSethDaniel/mason-tool-installer.nvim",

	"folke/neodev.nvim",
	"jose-elias-alvarez/null-ls.nvim",

	"numToStr/Comment.nvim",

	"simrat39/rust-tools.nvim",

	-- DAP
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",
	"theHamsta/nvim-dap-virtual-text",

	"mfussenegger/nvim-dap-python",
	"jbyuki/one-small-step-for-vimkind",

	{ "ziglang/zig.vim", ft = "zig" },
}

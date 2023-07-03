--[[ UI and colour stuff ]]

return {
	-- NOTE: colorbuddy has a bug and doesn't work on windows. Pull request for the fix is here:
	-- https://github.com/tjdevries/colorbuddy.nvim/pull/42
	-- colorscheme and tools
	-- { "tjdevries/colorbuddy.nvim", dev = false },
	-- { "tjdevries/gruvbuddy.nvim", dev = false },

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},

	-- statusline
	{ "tjdevries/express_line.nvim", dev = false },
}

--[[ Visual setup for nvim ]]

local has_tn, tokyonight = pcall(require, "tokyonight")
if has_tn then
	tokyonight.setup {
		style = "moon",
		terminal_colors = true,
		styles = {
			comments = { italic = false, },
			keywords = { italic = false, },
		},
	}

	vim.cmd.colorscheme("tokyonight")
end

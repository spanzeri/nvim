--[[
User and auto-commands
]]

local custom_highlight_group = vim.api.nvim_create_augroup("CustomHighlightGroup", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = custom_highlight_group,
	pattern = "*",
})

-- Trim whitespaces
-- TODO: when I finally make a plugin for project management, I should move this command and enable it on a
-- project basis on save

vim.api.nvim_create_user_command("TrimWhitespaces", [[:%s/\s\+$//e]], {})


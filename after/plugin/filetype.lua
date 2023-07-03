--[[ Filetype related config ]]

local ft_augroup = vim.api.nvim_create_augroup("CustomFtCmds", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.cmd.set "filetype=term"
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
	group = ft_augroup,
})

vim.api.nvim_create_autocmd("TermClose", {
	callback = function()
		vim.wo.number = vim.o.number
		vim.wo.relativenumber = vim.o.relativenumber
	end,
	group = ft_augroup,
})

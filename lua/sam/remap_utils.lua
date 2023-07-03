--[[ Remap utility functions ]]

local M = {}

M.nmap = function(args)
	vim.keymap.set("n", args[1], args[2], args[3])
end

M.imap = function(args)
	vim.keymap.set("i", args[1], args[2], args[3])
end

M.xmap = function(args)
	vim.keymap.set("x", args[1], args[2], args[3])
end

return M

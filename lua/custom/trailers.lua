--- trailer.lua
---
---     Copyright Samuele Panzeri 2023
--- Distributed under the Boost Software License, Version 1.0.
--- (See https://www.boost.org/LICENSE_1_0.txt)
---
--- ============================================================================
---
--- Features: Highlight and trim trailing whitespaces in a line or additional
--- empty lines at the end of a file.
--- Provide commands to clean a buffer manually or automatically on write.
---

-- Module definiton

local M = {}
local H = {}

M.setup = function(config)
	_G.Trailer = M
	config = H.make_config(config or {})
	H.create_autocommands()
	H.create_hl()

	vim.defer_fn(M.enable_hl, 0)
end

M.default_config = {
	enabled = true,
	only_normal_buffers = true,
	trim_on_write = false,
	empty_lines_eof = 1,
}

M.enable_hl = function()
	if not H.is_enabled() or vim.fn.mode() ~= "n" then
		M.disable_hl()
		return
	end

	if M.config.only_normal_buffers and not H.is_normal_buffer() then
		return
	end

	if H.get_match_id() ~= nil then
		return
	end

	vim.fn.matchadd("Trailer", [[\s\+$]])
	if M.config.empty_lines_eof == 0 then
		vim.fn.matchadd("Trailer", [[\v(^\s*\n$)\+%$\n]])
	else
		vim.fn.matchadd("Trailer",
			[[\v(^\s*\n$){]] .. tostring(M.config.empty_lines_eof) .. [[}\zs(^\s*\n$)+%$\n]])
	end

	-- \v(^\s*\n){2,}\ze^\s*\S   <- match empty lines inside file (not end)
end

M.disable_hl = function()
	while true do
		local id = H.get_match_id()
		if not id or id <= 0 then
			break
		end
		vim.fn.matchdelete(id)
	end
end

M.config = nil

-- Helper utils

H.make_config = function(config)
	vim.validate {{ config, "table", true }}
	config = vim.tbl_deep_extend("force", M.default_config, config or {})
	M.config = config

	vim.validate {
		{ config.enabled, "boolean" },
		{ config.only_normal_buffers, "boolean" },
		{ config.trim_on_write, "boolean" },
		{ config.empty_lines_eof, "number" },
	}

	return config
end

H.whitespace_pattern = [[\s\+$]]
H.eof_lines_pattern = [[\(^\s*\n$\)*\%$]]

H.create_autocommands = function()
	local augroup = vim.api.nvim_create_augroup("Trailer", { clear = true })
	local au = function(event, pattern, callback, desc)
		vim.api.nvim_create_autocmd(event, { group = augroup, pattern = pattern, callback = callback, desc = desc })
	end

	au({ "WinEnter", "BufEnter", "InsertLeave" }, "*", M.enable_hl, "Enable highlight")
	au({ "WinLeave", "BufLeave", "InsertEnter" }, "*", M.disable_hl, "Disable highlight")
end

H.create_hl = function()
	vim.api.nvim_set_hl(0, "Trailer", { default = true, link = "CurSearch" })
end


H.is_enabled = function()
	return not (vim.g.trailer_disable or vim.b.trailer_disable)
end

H.is_normal_buffer = function(id)
	return vim.api.nvim_buf_get_option(id or 0, 'buftype') == ""
end

H.get_match_id = function()
	for _, match in ipairs(vim.fn.getmatches()) do
		if match.group == "Trailer" then return match.id end
	end
end

return M


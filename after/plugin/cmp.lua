-- Autocompletion setup

local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local ok, luasnip = pcall(require, "luasnip")
if not ok then
	vim.api.nvim_err_writeln("Missing luasnip. cmp will not be enabled")
	return
end


local ok, lspkind = pcall(require, "lspkind")
if not ok then
	vim.api.nvim_err_writeln("Missing luasnip. cmp will not be enabled")
	return
end

local has_word_before = function()
	local unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
	-- tab and S-tab to cycle suggestions (sorry TJ, I like it this way)
	mapping = {
		["<tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_previous_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-space>"] = cmp.mapping(function(_)
			if cmp.visible() then
				cmp.confirm { select = true }
			else
				cmp.complete()
			end
		end, { "i", "s" }),
	},

	-- source: according to TJ's config, the order matter (for priority)
	sources = cmp.config.sources({
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		-- todo: if I add copilot or similar, it should go here <---
	}, {
		{ name = "path" },
		{ name = "buffer", keyword_length = 5 },
	}),

	-- sorting (prefer members that do not start with _)
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.source,
			cmp.config.compare.recently_used,

			function(e1, e2)
				local _, e1_starts_under = e1.completion.item.label:find("^_+")
				local _, e2_starts_under = e2.completion.item.label:find("^_+")
				e1_starts_under = e1_starts_under or 0
				e2_starts_under = e2_starts_under or 0
				if e1_starts_under > e2_starts_under then
					return false
				elseif e1_starts_under < e2_starts_under then
					return true
				end
			end,

			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	formatting = {
		format = lspkind.cmp_format {
			mode = "symbol_text",
			preset = "default",
		},
	}
}


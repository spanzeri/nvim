--[[ Setup for utility plugins ]]

local nmap = require("sam.remap_utils").nmap

if vim.cmd.UndotreeToggle then 
	nmap { "<leader>ut", vim.cmd.UndotreeToggle, { desc = "[u]ndotree [t]oggle" } }
	nmap { "<leader>uf", vim.cmd.UndotreeFocus, { desc = "[u]ndotree [f]ocus" } }
	nmap { "<leader>uc", vim.cmd.UndotreeHide, { desc = "[u]ndotree [c]lose" } }
end

local ok, ntree = pcall(require, "neo-tree")
if ok then
	ntree.setup {
		close_if_last_window = true,
		window = {
			width = 40,
		},
	}

	nmap { "\\", "<cmd>Neotree reveal<cr>", { desc = "neotree focus" } } 
	nmap { "|", "<cmd>Neotree show toggle<CR>", { desc = "neotree toggle" } }
end

local ok, colorizer = pcall(require, "colorizer")
if ok then
	colorizer.setup()
end

local ok, indent_blankline = pcall(require, "indent_blankline")
if ok then
	indent_blankline.setup()
end

local has_orgmode, orgmode = pcall(require, "orgmode")
if has_orgmode then
	orgmode.setup_ts_grammar()
	orgmode.setup()
end

local has_wk, wk = pcall(require, "which-key")
if has_wk then
	vim.o.timeout = true
	vim.o.timeoutlen = 300
	wk.setup()

	wk.register({
		c = { name = "Code" },
		d = { name = "Diagnostic|Debug" },
		e = { name = "Errors" },
		g = { name = "Git" },
		o = { name = "Org" },
		s = { name = "Search" },
		t = { name = "Treesiteer" },
		u = { name = "Undo" },
		x = { name = "Source" },
	}, { prefix = "<leader>" })
end

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

--[[ Treesitter config ]]

local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
	return
end

require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"glsl",
		"go",
		"hlsl",
		"json",
		"lua",
		"markdown",
		"meson",
		"ocaml",
		"python",
		"rust",
		"toml",
		"vim",
		"vimdoc",
		"zig",
	},

	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },

	incremental_selection = {
		enable = true,
		lookahead = true,
		keymaps = {
			init_selection = "<C-s>",
			node_incremental = "<C-s>",
			scope_incremental = "<C-S>",
			node_decremental = "<M-s>",
		},
	},

	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			c = "// %s",
			lua = "-- %s",
		},
	},

	textobjects = {
		move = {
			enable = true,
			set_jumps = true,

			goto_next_start = {
				["]p"] = "@parameter.inner",
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[p"] = "@parameter.inner",
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},

		select = {
			enable = true,
			lookahead = true,

			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",

				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",

				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",

				["av"] = "@variable.outer",
				["iv"] = "@variable.inner",
			},
		},
	},

	playground = {
		enable = true,
		updatetime = 25,
		persist_queries = true,
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
}

local nmap = require("sam.remap_utils").nmap

nmap { "<leader>tp", "<cmd>TSPlaygroundToggle<CR>", { desc = "[t]reesitter [p]layground" } }
nmap { "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>", { desc = "[t]reesitter [h]ighlight capture under cursor" } }

--[[ Telescope config ]]

local ok, ts = pcall(require, "telescope")
if not ok then
	return
end

ts.setup {
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown {
				layout_config = {
					width = 0.5
				},
			}
		},
	},
	defaults = {
		winblend = 5,
		layout_config = {
			width = 220,
			vertical = {
				preview_width = 110,
				preview_cutoff = 180,
			},
			height = 0.5,
		},
		shorten_path = true,
	},
}

ts.load_extension("ui-select")

local has_ts_custom, tsbuiltin = pcall(require, "sam.telescope_custom")
if not has_ts_custom then
	return
end

-- dev reload
local reload = function(mod)
	_G.package.loaded[mod] = nil
	return require(mod)
end
tsbuiltin = reload("sam.telescope_custom")

local nmap = require("sam.remap_utils").nmap

-- keymaps

nmap { "<leader>/", tsbuiltin.current_buffer_fuzzy_find, { desc = "fuzzy search current buffer [/]" } }
nmap { "<leader>st", tsbuiltin.builtin, { desc = "[s]earch [t]elescope builtins" } }
nmap { "<leader>sh", tsbuiltin.help_tags, { desc = "[s]earch [h]elp" } }
nmap { "<leader>sf", tsbuiltin.find_files, { desc = "[s]earch [f]iles" } }
nmap { "<leader>so", tsbuiltin.oldfiles, { desc = "[s]earch [o]ld files"} }
nmap { "<leader>sb", tsbuiltin.buffers, { desc = "[s]earch [b]uffers"} }
nmap { "<leader>sn", tsbuiltin.nvim_config, { desc = "[s]earch [n]vim config files" } }
nmap { "<leader>sw", tsbuiltin.grep_string, { desc = "[s]earch current [w]ord" } }
nmap { "<leader>sg", tsbuiltin.live_grep, { desc = "[s]earch by [g]rep" } }
nmap { "<leader>sd", tsbuiltin.diagnostics, { desc = "[s]earch [d]iagnostics" } }
nmap { "<leader>sj", tsbuiltin.jumplist, { desc = "[s]earch [j]umplist" } }
nmap { "<leader>sk", tsbuiltin.keymaps, { desc = "[s]earch [k]eymaps" } }
nmap { "<leader>sr", tsbuiltin.registers, { desc = "[s]earch [r]egisters" } }
nmap { "<leader>se", tsbuiltin.quickfix, { desc = "[s]earch [e]rrors" } }

-- git
nmap { "<leader>sgf", tsbuiltin.git_files, { desc = "[s]earch [g]it [f]iles" } }
nmap { "<leader>sgb", tsbuiltin.git_branches, { desc = "[s]earch [g]it [b]ranches" } }
nmap { "<leader>sgc", tsbuiltin.git_commits, { desc = "[s]earch [g]it [c]ommits" } }


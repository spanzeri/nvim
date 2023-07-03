--[[ Basic keymaps
Keymaps we always want available, with or without plugins
]]

local remap_utils = require("sam.remap_utils")
local nmap = remap_utils.nmap
local xmap = remap_utils.xmap
local imap = remap_utils.imap

-- Better movement with word-wrap
nmap { "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true } }
nmap { "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true } }

-- Ensure jumping to the end of the page leaves some space under the cursor
nmap { "G", [[G8<C-e>]] }

-- Ctrl+Backspace and Ctrl+Del in insert mode
imap { "<C-del>", "<C-o>dw" }
imap { "<C-BS>", "<C-o>db" }
imap { "<C-h>", "<C-o>db" } -- support for terminals that remap C-BS to C-h

-- Yank to and paste from system clipboard
xmap { "<leader>p", [["_dP]], { desc = "[p]aste and preserve register" } }
xmap { "<leader>P", [["+dP]], { desc = "[P]aste from system" } }
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "[y]ank to system" })
vim.keymap.set({ "n", "x" }, "<leader>Y", [["+Y]], { desc = "[Y]ank line to system" })
nmap { "<leader>p", [["+p]], { desc = "[p]aste from sytem" } }
nmap { "<leader>P", [["+P]], { desc = "[P]aste before cursor from sytem" } }

-- Diagnostic and error navigation and windows
nmap { "[d", vim.diagnostic.goto_prev, { desc = "go to previous [d]iagnostic" } }
nmap { "]d", vim.diagnostic.goto_prev, { desc = "go to next [d]iagnostic" } }
nmap { "[e", vim.cmd.cprev, { desc = "go to previous [e]rror", silent = true } }
nmap { "]e", vim.cmd.cnext, { desc = "go to next [e]rror", silent = true } }
nmap { "<leader>df", vim.diagnostic.open_float, { desc = "open [d]iagnostic [f]loat" } }
nmap { "<leader>dl", vim.diagnostic.setloclist, { desc = "open [d]iagnostic [l]ist" } }
-- @TODO: error list and float
nmap { "<leader>el", function() vim.cmd.copen { count = 20 } end, { desc = "open [e]rror [l]ist" } }

-- Diff
nmap { "gh", "<cmd>diffget //2<CR>", { silent = true, desc = "diff[g]et left [h]" } }
nmap { "gl", "<cmd>diffget //3<CR>", { silent = true, desc = "diff[g]et left [l]" } }

-- Quickly execute lua stuff
nmap { "<leader>xx", "<cmd>w | so %<CR>", { desc = "save and source current lua file" } }

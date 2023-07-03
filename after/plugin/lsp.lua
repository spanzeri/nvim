--[[ LSP config ]]

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
	return
end

local neodev = vim.F.npcall(require, "neodev")
if neodev then
	neodev.setup {
		override = function(_, library)
			library.enabled = true
			library.plugins = true
		end,
		lspconfig = true,
		pathStrict = true,
	}
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

local has_mason, mason = pcall(require, "mason")
local has_mason_l, mason_lspconfig = pcall(require, "mason-lspconfig")
local has_mason_ti, mason_tool_installer = pcall(require, "mason-tool-installer")
if not has_mason or not has_mason_l or not has_mason_ti then
	vim.api.nvim_err_write("mason, mason-lspconfig or mason-tool-installer are missing, lsp won't work")
	return
end

mason.setup()
mason_lspconfig.setup {
	ensure_installed = {
		"lua_ls", "jsonls", "clangd"
	},
}
mason_tool_installer.setup {
	auto_update = true,
	debounce_hours = 24,
	ensure_installed = {
		"black",
		"isort",
		"codelldb",
	},
}

local remap_utils = require("sam.remap_utils")
local nmap = remap_utils.nmap
local imap = remap_utils.imap

-- buffer remaps helpers

local bufnmap = function(opts)
	opts[3] = opts[3] or {}
	opts[3].buffer = 0
	nmap(opts)
end

local bufimap = function(opts)
	opts[3] = opts[3] or {}
	opts[3].buffer = 0
	imap(opts)
end

-- telescope mappings
local has_tscope, tsbuiltin = pcall(require, "sam.telescope_custom") 

-- autocommand helpers
local augroup_highlights = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })

local autocmd_clear = vim.api.nvim_clear_autocmds
local autocmd_create = vim.api.nvim_create_autocmd

-- custom init function
local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

-- custom attach function that register keymaps
local custom_attach = function(client, bufnr)
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")

	bufimap { "<C-s>", vim.lsp.buf.signature_help }

	bufnmap { "<leader>cr", vim.lsp.buf.rename, { desc = "[c]ode [r]ename" } }
	bufnmap { "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ction" } }

	bufnmap { "gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" } }
	bufnmap { "gD", vim.lsp.buf.declaration, { desc = "[g]o to [D]eclaration" } }
	bufnmap { "gT", vim.lsp.buf.type_definition, { desc = "[g]o to [T]ype definiton" } }
	bufnmap { "K", vim.lsp.buf.hover, { desc = "lsp:hover [D]" } }
	bufnmap { "gI", vim.lsp.buf.implementation, { desc = "[g]o to [I]mplementation" } }

	if has_tscope then
		bufnmap { "gr", [[<cmd>Telescope lsp_references<CR>]], { desc = "[g]o to [r]eferences under cursor" } }
		bufnmap { "gI", [[<cmd>Telescope lsp_implementations<CR>]], { desc = "[g]o to [I]mplementations under cursor" } }
		bufnmap { "<leader>ss", [[<cmd>Telescope lsp_document_symbols]], { desc = "[s]earch document [s]ymbols" } }
		bufnmap { "<leader>sS", [[<cmd>Telescope lsp_workspace_symbols]], { desc = "[s]earch workspace [S]ymbols" } }
	end

	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	if client.server_capabilities.documentHighlightProvider then
		autocmd_clear { group = augroup_highlights, buffer = bufnr }
		autocmd_create("CursorHold", {
			buffer = bufnr,
			group = augroup_highlights,
			callback = vim.lsp.buf.document_highlight,
		})
		autocmd_create("CursorMoved", {
			buffer = bufnr,
			group = augroup_highlights,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if filetype == "typescript" or filetype == "lua" then
		client.server_capabilities.semanticTokensProvider = nil
	end

	filetype_attach[filetype]()
end

-- rust analyzer stuff
local rust_analyzer, rust_analyzer_cmd = nil, { "rustup", "run", "nightly", "rust-analyzer" }
local has_rt, rt = pcall(require, "rust-tools")
if has_rt then
	local mason_codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/"
	local codelldb_path = mason_codelldb_path .. "codelldb"
	local liblldb_path = mason_codelldb_path .. "liblldb"

	rt.setup {
		server = {
			cmd = rust_analyzer_cmd,
			capabilities = capabilities,
			on_attach = custom_attach,
		},
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
		},
	}
else
	rust_analyzer = {
		cmd = rust_analyzer_cmd,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	}
end

local servers = {
	bashls = true,
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},

	gdscript = true,
	pyright = true,
	vimls = true,
	ocamllsp = {
		get_language_id = function(_, ft)
			return ft
		end,
	},

	jsonls = {
		settings = {
			json = {
				validate = { enable = true },
			},
		},
	},

	cmake = (1 == vim.fn.executable "cmake-language-server"),

	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--suggest-missing-includes",
			"--clang-tidy",
			"--header-insertion=iwyu",
		},
		init_options = {
			clangdFileStatus = true,
		},
	},

	zls = true,
}

local setup_server = function(server, config)
	if not config then
		return
	end

	if type(config) ~= "table" then
		config = {}
	end

	config = vim.tbl_deep_extend("force", {
		on_init = custom_init,
		on_attach = custom_attach,
		capabilities = capabilities,
	}, config)

	lspconfig[server].setup(config)
end
--
-- actual code that setup all the LSPs above
for server, config in pairs(servers) do
	setup_server(server, config)
end

require("null-ls").setup {
	sources = {
		require("null-ls").builtins.formatting.prettierd,
		require("null-ls").builtins.formatting.isort,
		require("null-ls").builtins.formatting.black,
	},
}

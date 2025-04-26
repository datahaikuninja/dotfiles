return {
	{ "neovim/nvim-lspconfig" },
	{ "onsails/lspkind.nvim" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/vim-vsnip" },
	{ "hrsh7th/cmp-vsnip" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "copilot",                keyword_length = 2 },
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "buffer",                 keyword_length = 3 },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-l>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				}),
				experimental = {
					ghost_text = false,
				},
				formatting = {
					format = lspkind.cmp_format({
						-- workaround to long label details.
						-- see: https://github.com/hrsh7th/nvim-cmp/issues/1154#issuecomment-1872926479
						before = function(entry, vim_item)
							local m = vim_item.menu and vim_item.menu or ""
							local len = 15
							if #m > len then
								vim_item.menu = string.sub(m, 1, len) .. "..."
							end
							return vim_item
						end,
						mode = "symbol",
						maxwidth = 50,
						symbol_map = {
							Copilot = "",
						},
						ellipsis_char = "...",
					}),
				},
			})
			-- `/`, `?` cmdline setup.
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
	{ "williamboman/mason.nvim",   build = ":MasonUpdate", opts = {} },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pylsp",
					"terraformls",
					"tflint",
					"gopls",
					"rust_analyzer",
				},
			})
			local on_attach = function(client, bufnr)
				-- keymaps for lsp
				local set = vim.keymap.set
				set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
				set("n", "gK", "<cmd>Lspsaga hover_doc<CR>")
				-- set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
				set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")
				set("n", "gn", "<cmd>Lspsaga rename<CR>")
				-- set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- replace by actions-preview
				set("n", "gr", "<cmd>Lspsaga finder<CR>")
				set("n", "<space>l", "<cmd>Lspsaga show_line_diagnostics<CR>")
				set("n", "<space>b", "<cmd>Lspsaga show_buf_diagnostics<CR>")
				set("n", "<space>w", "<cmd>Lspsaga show_workspace_diagnostics ++normal<CR>")
				set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
				set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["pylsp"] = function()
					require("lspconfig").pylsp.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							pylsp = {
								configurationSources = { "flake8", "pycodestyle" },
								plugins = {
									pycodestyle = { enabled = false },
									flake8 = {
										enabled = true,
										maxLineLength = 120,
									},
								},
							},
						},
					})
				end,
				["gopls"] = function()
					require("lspconfig").gopls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
								},
								staticcheck = true,
								gofumpt = false,
							},
						},
					})
				end,
				-- see:
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
				-- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
				-- https://rust-analyzer.github.io/manual.html#nvim-lsp
				["rust_analyzer"] = function()
					require("lspconfig").rust_analyzer.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								check = {
									-- rust-analyzer.check.command
									-- see: https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
									command = "clippy",
								},
							},
						},
					})
				end,
			})
			vim.diagnostic.config({ virtual_text = false, severity_sort = true })
			-- avoid increasing LSP log filesize
			vim.lsp.set_log_level(vim.log.levels.ERROR)

			-- go-fmt on save
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					local params = vim.lsp.util.make_range_params()
					params.context = { only = { "source.organizeImports" } }
					-- buf_request_sync defaults to a 1000ms timeout. Depending on your
					-- machine and codebase, you may want longer. Add an additional
					-- argument after params if you find that you have to write the file
					-- twice for changes to be saved.
					-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end
					vim.lsp.buf.format({ async = false })
				end,
			})

			-- see: https://minerva.mamansoft.net/Notes/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8C%E4%BF%9D%E5%AD%98%E3%81%95%E3%82%8C%E3%81%9F%E3%82%89%E8%87%AA%E5%8B%95%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88+(nvim-lspconfig)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = { "*.rs" },
						callback = function()
							vim.lsp.buf.format({
								buffer = event.buf,
								async = false,
							})
						end,
					})
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.lua",
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			-- see: https://github.com/nvimtools/none-ls.nvim?tab=readme-ov-file#setup
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.golangci_lint.with({
						condition = function(utils)
							return utils.root_has_file({ "go.mod" }) and utils.root_has_file({ ".golangci.yml" })
						end,
						extra_args = { "--config=$ROOT/.golangci.yml" },
					}),
				},
			})
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
		opts = {
			definition = { width = 0.9, height = 0.8 },
			finder = { layout = "normal" },
			symbol_in_winbar = { enable = false },
			lightbulb = { sign = false, virtual_text = false },
		},
	},
	{ "maxandron/goplements.nvim", ft = "go",              opts = {} },
}

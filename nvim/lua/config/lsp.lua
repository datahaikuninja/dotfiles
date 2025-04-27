vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
})

vim.lsp.set_log_level(vim.log.levels.ERROR)

-- config for all Language Server
vim.lsp.config("*", {
  on_attach = function(client, bufnr)
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
  end,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- config for pylsp
vim.lsp.config("pylsp", {
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

-- config for gopls
vim.lsp.config("gopls", {
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

-- config for rust-analyzer
vim.lsp.config("rust_analyzer", {
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

-- rustfmt on save
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

-- enable all Language Server installed by mason
vim.lsp.enable(require("mason-lspconfig").get_installed_servers())

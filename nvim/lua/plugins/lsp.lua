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
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
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
  { "maxandron/goplements.nvim", ft = "go", opts = {} },
}

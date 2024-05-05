-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "EdenEast/nightfox.nvim",
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "neovim/nvim-lspconfig",
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  "williamboman/mason-lspconfig.nvim",
  "nvimtools/none-ls.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/vim-vsnip",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "onsails/lspkind.nvim",
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  "windwp/nvim-autopairs",
  "nvim-lua/plenary.nvim",
  "lewis6991/gitsigns.nvim",
  "sindrets/diffview.nvim",
  { "j-hui/fidget.nvim", tag = "legacy" },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
  },
  "zbirenbaum/copilot.lua",
  "zbirenbaum/copilot-cmp",
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
    },
  },
  { "sankantsu/telescope-zenn.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
  { "SmiteshP/nvim-navic", dependencies = "neovim/nvim-lspconfig" },
  {
    "SmiteshP/nvim-navbuddy",
    dev = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      -- "numToStr/Comment.nvim",        -- Optional
      "nvim-telescope/telescope.nvim",
    },
  },
  { "mvllow/modes.nvim", tag = "v0.2.0" },
  { "shellRaining/hlchunk.nvim", event = { "UIEnter" } },
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      -- { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
  },
  { "folke/neodev.nvim", opts = {} }, -- highly recommended to use nvim-dap-ui
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
})

-- starts general settings for Neovim
-- e.g. appearance, blank, brackets, keymaps, autocmd ..

vim.opt.number = true
vim.opt.termguicolors = true
-- vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.list = true
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("space:⋅")
vim.opt.nrformats = "bin,hex,alpha"
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.ignorecase = true
vim.opt.hidden = true
vim.g.mapleader = ","

vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })
vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR>", { noremap = true })
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

vim.keymap.set("n", "<C-t>", "<cmd>tabprevious<CR>", { silent = true })

-- use hard tabs for golang
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*.go",
  command = [[setlocal noexpandtab]],
})

-- use soft tabs, 4 spaces for python
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.py" },
  command = [[setlocal expandtab tabstop=4 shiftwidth=4]],
})

-- use soft tabs, 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "*.tf", "*.js", "sh", "*.lua", "lua", "hcl", "jsonnet", "markdown" },
  command = [[setlocal expandtab tabstop=2 shiftwidth=2]],
})

-- disable auto commenting
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("turn_off_auto_commenting", {}),
  pattern = "*",
  command = [[setlocal fo-=cro]],
})

-- autopairs
require("nvim-autopairs").setup()

-- :h nvim-surround.usage
require("nvim-surround").setup()

-- ends general settings for Neovim

-- starts settings for colorscheme

-- require("nightfox").setup({
--   options = {
--     transparent = true,
--     styles = {
--       comments = "italic",
--     },
--   },
-- })
-- vim.cmd("colorscheme nightfox")

require("tokyonight").setup({
  style = "moon",
  transparent = true,
  styles = {
    comments = { italic = true },
  },
})

vim.cmd("colorscheme tokyonight")

-- end settings for colorscheme

-- starts settings for terminal

require("toggleterm").setup({})
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "tab",
  float_opts = { border = "single" },
})
function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tt", ":ToggleTerm direction=tab<CR>", { noremap = true })

-- ends settigs for teminal

-- starts settigs for treesitter

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "python",
    "lua",
    "terraform",
    "markdown",
    "markdown_inline",
    "javascript",
    "go",
    "hcl",
    "jsonnet",
  },
  highlight = {
    enable = true,
  },
})

require("hlchunk").setup({})

-- end settings for treesitter

-- starts settings for LSP

require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

vim.opt.signcolumn = "yes"
require("lspsaga").setup({
  symbol_in_winbar = {
    enable = false,
  },
  lightbulb = {
    sign = false,
    virtual_text = false,
  },
})

local on_attach = function(client, bufnr)
  -- keymaps for lsp
  local set = vim.keymap.set
  set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
  set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
  -- set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")
  set("n", "rn", "<cmd>Lspsaga rename<CR>")
  -- set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- replace by actions-preview
  set("n", "gr", "<cmd>Lspsaga finder<CR>")
  set("n", "<space>e", "<cmd>Lspsaga show_line_diagnostics<CR>")
  set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pylsp",
    "terraformls",
    "tflint",
    "gopls",
  },
})
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
          gofumpt = true,
        },
      },
    })
  end,
})

vim.diagnostic.config({ virtual_text = false })

-- avoid increasing LSP log filesize
vim.lsp.set_log_level("off")

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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- display nvim-lsp progress
require("fidget").setup()

-- breadcrumb
require("nvim-navic").setup({
  lsp = {
    auto_attach = true,
  },
  highlight = true,
})

require("nvim-navbuddy").setup({
  window = {
    size = { height = "40%", width = "100%" },
    position = { row = "100%", col = "50%" },
  },
  lsp = {
    auto_attach = true,
  },
})

-- ends settings for LSP

-- starts settings for DAP

require("mason-nvim-dap").setup({
  ensure_installed = { "delve" },
  handlers = {
    function(config)
      require("mason-nvim-dap").default_setup(config)
    end,
  },
})

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F6>", function()
  require("dap").terminate()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
  require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
  require("dap").set_breakpoint()
end)
vim.keymap.set("n", "<Leader>lp", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
  require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
  require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set("n", "<leader>d", function()
  require("dapui").toggle()
end)
vim.keymap.set("n", "<leader>df", function()
  require("dapui").eval()
end)

require("dapui").setup({})

-- end settings for DAP

-- starts settings for completion

local lspkind = require("lspkind")
local cmp = require("cmp")

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
    { name = "copilot", keyword_length = 2 },
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "buffer", keyword_length = 3 },
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

-- ends settings for completion

-- starts settings for statusline

require("lualine").setup({
  sections = {
    lualine_a = {},
    lualine_b = { "branch", "diagnostics" },
    lualine_c = {
      "filename",
      {
        "navic",
        color_correction = nil,
        navic_opts = nil,
      },
    },
    lualine_x = { "Filetype" },
    lualine_y = {},
    lualine_z = {},
  },
  options = {
    section_separators = "",
    globalstatus = false,
  },
})

-- for minimalistic statusline
require("modes").setup({
  colors = {
    copy = "#D3B461",
    delete = "#BB385A",
    insert = "#6FA589",
    visual = "#8A5FCC",
  },
  line_opacity = 0.3,
  set_cursor = true,
  set_cursorline = true,
  set_number = true,
  ignore_filetypes = { "NvimTree", "TelescopePrompt" },
})

-- end settings for statusline

-- starts settings for fuzzyfinder

local builtin = require("telescope.builtin")
-- keymaps for telescope
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      horizontal = { preview_cutoff = 0 },
      vertical = {
        height = function(_, _, max_lines)
          return max_lines
        end,
        preview_cutoff = 0,
        preview_height = 8,
      },
    },
    preview = {
      ls_short = true,
    },
  },
  --extensions = {},
})

vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })

-- ends settings for fuzzyfinder

-- starts settings for Git and GitHub

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
  },
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Actions
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hn", gs.next_hunk)
    map("n", "<leader>hs", gs.stage_hunk)
    map("n", "<leader>hr", gs.reset_hunk)
    map("n", "<leader>hS", gs.stage_buffer)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>tb", gs.toggle_current_line_blame)
  end,
})

require("diffview").setup()

-- github copilot
require("copilot").setup({
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = false,
  },
  filetypes = {
    "yaml",
    "markdown",
    "gitcommit",
  },
})

require("copilot_cmp").setup()

require("CopilotChat").setup({})
-- Quick chat with your buffer
function CopilotChatBuffer()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end

vim.keymap.set("n", "<leader>ccq", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })

-- display a prompt to the user to select an action from a list of available actions in Copilot Chat.
function ShowCopilotChatActionPrompt()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end

vim.keymap.set("n", "<leader>ccp", "<cmd>lua ShowCopilotChatActionPrompt()<cr>", { noremap = true, silent = true })

function ShowCopilotChatHelpPrompt()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.help_actions())
end

vim.keymap.set("n", "<leader>cch", "<cmd>lua ShowCopilotChatHelpPrompt()<cr>", { noremap = true, silent = true })

require("octo").setup({
  enable_builtin = true,
})
vim.cmd([[hi OctoEditable guibg=none]])
vim.keymap.set("n", "<leader>o", "<cmd>Octo<CR>", { noremap = true })

-- end settings for Git and GitHub

-- starts settings for filer

require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- end settings for filer

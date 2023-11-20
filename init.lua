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
    {"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "neovim/nvim-lspconfig",
    {"williamboman/mason.nvim", build = ":MasonUpdate"},
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "onsails/lspkind.nvim",
    {"nvim-lualine/lualine.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}},
    "windwp/nvim-autopairs",
    "nvim-lua/plenary.nvim",
    "lewis6991/gitsigns.nvim",
    {"j-hui/fidget.nvim", tag = "legacy"},
    {"nvim-telescope/telescope.nvim", tag = "0.1.4", dependencies = {"nvim-lua/plenary.nvim"}},
    {"nvim-telescope/telescope-file-browser.nvim", dependencies = {"nvim-telescope/telescope.nvim"}},
    {"glepnir/lspsaga.nvim", event = "LspAttach", dependencies = {"nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter"}},
    "zbirenbaum/copilot.lua",
    {"sankantsu/telescope-zenn.nvim", dependencies = {"nvim-telescope/telescope.nvim",}},
})

-- set options
vim.opt.number = true
vim.opt.termguicolors = true
-- vim.opt.expandtab = true
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
vim.opt.clipboard:append{"unnamedplus"}
vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"
vim.opt.nrformats = "bin,hex,alpha"
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.ignorecase = true

-- use hard tabs for golang
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.go",
    command = [[setlocal noexpandtab]],
})

-- use soft tabs, 4 spaces for python
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*.py",
    command = [[setlocal expandtab tabstop=4 shiftwidth=0]],
})

-- use soft tabs, 2 spaces
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"terraform", "*.tf", "*.js"},
    command = [[setlocal expandtab tabstop=2 shiftwidth=0]],
})

-- set keymaps
vim.keymap.set("c", "<C-p>", "<Up>", {noremap = true})
vim.keymap.set("c", "<C-n>", "<Down>", {noremap = true})
vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR>", {noremap = true})
vim.keymap.set("n", "tv", "<cmd>vsplit term://zsh<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "th", "<cmd>split term://zsh<CR>", {noremap = true, silent = true})
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", {noremap = true})

-- terminal emulator settings
-- open terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
    command = [[startinsert]],
})

-- disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
    command = [[setlocal nonumber norelativenumber]],
})

-- treesitter settings
require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "python",
        "lua",
        "terraform",
        "markdown",
        "markdown_inline",
        "javascript",
        "go",
    },
    highlight = {
        enable = true,
    }
}

-- lsp settings
local on_attach = function(client, bufnr)
    local set = vim.keymap.set
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
    set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
    set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
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
    }
})
require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                -- configure plugins in pylsp
                pylsp = {
                    configurationSources = {"flake8", "pycodestyle"},
                    plugins = {
                        pycodestyle = {enabled = false},
                        flake8 = {
                            enabled = true,
                            maxLineLength = 120,
                        },
                    }
                },
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })
    end
})

vim.diagnostic.config({virtual_text = false})

-- go-fmt on save
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
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
    vim.lsp.buf.format({async = false})
  end
})

-- cmp settimgs
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
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "path" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-l>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    }),
    experimental = {
        ghost_text = false
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
        })
    }
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

local mapping_cmdline = cmp.mapping.preset.cmdline()
mapping_cmdline['<Tab>'] = function (fallback)
    if cmp.visible() then
        cmp.select_next_item()
    else
        fallback()
    end
end

cmp.setup.cmdline(":", {
    mapping = mapping_cmdline,
    sources = cmp.config.sources({
        { name = 'cmdline' }
    }, {
        { name = 'path'}
    })
})

-- diagnostic, formatting
-- remove mason-null-ls and null-ls

-- colorscheme settings
require("nightfox").setup({
    options = {
        transparent = false,
        styles = {
            comments = "italic",
        }
    }
})

-- load colorscheme
vim.cmd("colorscheme nightfox")

-- statusline
require("lualine").setup({
    options = {
        section_separators = "",
        globalstatus = true
    }
})

-- autopairs
require("nvim-autopairs").setup()

-- git
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
    end
})

-- display nvim-lsp progress
require("fidget").setup()

-- fuzzyfinder
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

require("telescope").setup({
    defaults = {
        preview = {
            ls_short = true,
        },
    },
    extensions = {
        file_browser = {
            theme = "ivy",
            hijack_netrw = false,
        }
    }
})

require("telescope").load_extension "file_browser"

vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser<CR>",
  { noremap = true }
)

-- lspsaga
require("lspsaga").setup()

-- github copilot
require("copilot").setup({
    suggestion = {
        auto_trigger = true,
    }
})

-- indent_blankline settings
require("ibl").setup ({
    indent = {
        char = "▏",
    },
    scope = { enabled = false }
})

-- disable auto commenting
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("turn_off_auto_commenting", {}),
    pattern = "*",
    command = [[setlocal fo-=cro]]
})

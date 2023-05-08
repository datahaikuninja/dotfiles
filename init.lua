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
    "lukas-reineke/indent-blankline.nvim",
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
    {"jay-babu/mason-null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {"williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim"},
    },
    "nvim-lua/plenary.nvim",
    "ErichDonGubler/lsp_lines.nvim",
    "lewis6991/gitsigns.nvim",
    "j-hui/fidget.nvim",
    {"nvim-telescope/telescope.nvim", tag = "0.1.1", dependencies = {"nvim-lua/plenary.nvim"}},
    {"glepnir/lspsaga.nvim", event = "LspAttach", dependencies = {"nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter"}},
})

-- set options
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard:append{"unnamedplus"}
vim.opt.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"
vim.opt.nrformats = "bin,hex,alpha"
vim.opt.wildmenu = true
vim.opt.wildmode = "full"

-- set keymaps
vim.keymap.set("c", "<C-p>", "<Up>", {noremap = true})
vim.keymap.set("c", "<C-n>", "<Down>", {noremap = true})

-- inident_blankline settings
require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}

-- treesitter settings
require("nvim-treesitter.configs").setup {
    ensure_installed = {"python", "lua", "terraform", "markdown", "markdown_inline"},
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
    set("n", "<space>e", "<cmd>lua vim.lsp.diagonostic.show_line_diagonostics()<CR>")
    set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
    set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end
})

vim.diagnostic.config({virtual_text = false}) -- recommended by lsp_lines
require("lsp_lines").setup()

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
local mason_null_ls = require("mason-null-ls")
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.flake8,
    }
})

mason_null_ls.setup({
    ensure_installed = nil,
    automatic_installation = true,
})

-- colorscheme settings
require("nightfox").setup({
    options = {
        transparent = true,
    }
})

-- load colorscheme
vim.cmd("colorscheme nightfox")

-- statusline
require("lualine").setup()

-- autopairs
require("nvim-autopairs").setup()

-- git
require("gitsigns").setup()

-- display nvim-lsp progress
require("fidget").setup()

-- fuzzyfinder
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

require("telescope").setup()

-- lspsaga
require("lspsaga").setup()


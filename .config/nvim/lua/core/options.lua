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
-- vim.g.mapleader = "," -- set in plugins/init.lua
vim.opt.grepprg = "rg --vimgrep"
vim.opt.signcolumn = "yes"

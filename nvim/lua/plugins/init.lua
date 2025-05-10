-- Bootstrap lazy.nvim
-- refer to "https://lazy.folke.io/installation"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
-- available options listed in "https://lazy.folke.io/configuration"
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins.core" },
    { import = "plugins.colorscheme" },
    { import = "plugins.treesitter" },
    { import = "plugins.multi-tool" },
    --{ import = "plugins.fuzzyfinder" },
    { import = "plugins.terminal" },
    { import = "plugins.surround" },
    { import = "plugins.status" },
    { import = "plugins.filer" },
    { import = "plugins.quickfix" },
    { import = "plugins.outline" },
    { import = "plugins.move-cursor" },
    { import = "plugins.lsp" },
    { import = "plugins.debugger" },
    { import = "plugins.git-util" },
    { import = "plugins.markdown" },
    { import = "plugins.ai" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- load colorscheme
vim.cmd("colorscheme tokyonight")

-- set lazygit shortcut
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

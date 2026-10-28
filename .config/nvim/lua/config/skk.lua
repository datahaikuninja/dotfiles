-- ref: https://github.com/sankantsu/dotfiles/blob/main/nvim/init.lua
vim.cmd([[
call skkeleton#config({ 'globalDictionaries': ['~/.skk/SKK-JISYO.L'] })
imap <C-j> <Plug>(skkeleton-enable)
imap <C-k> <Plug>(skkeleton-disable)

call skkeleton#register_kanatable("rom", {
  \ "ca": ["か"],
  \ "cu": ["く"],
  \ "co": ["こ"],
  \ "xn": ["ん"],
  \ })
]])

-- Limit cmp sources to skkeleton while SKK is on to cut per-key lag.
local group = vim.api.nvim_create_augroup("skkeleton-cmp", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "skkeleton-enable-pre",
  callback = function()
    require("cmp").setup.buffer({ sources = { { name = "skkeleton" } } })
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "skkeleton-disable-pre",
  callback = function()
    -- An empty buffer config falls back to the global one.
    require("cmp").setup.buffer({})
  end,
})

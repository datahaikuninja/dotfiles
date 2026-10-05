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

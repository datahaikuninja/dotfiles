-- disable auto commenting
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("turn_off_auto_commenting", {}),
  pattern = "*",
  command = [[setlocal fo-=cro]],
})
-- utility function
-- Converts the immediately preceding word to uppercase
vim.keymap.set("i", "<C-u>", function()
  local line = vim.fn.getline(".")
  local col = vim.fn.getpos(".")[3]
  local substring = line:sub(1, col - 1)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return "<C-w>" .. result:upper()
end, { expr = true })

-- use hard tabs for golang
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*.go",
  command = [[setlocal noexpandtab]],
})

-- use soft tabs, 4 spaces for rust
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust" },
  command = [[setlocal expandtab tabstop=4 shiftwidth=4]],
})

-- use soft tabs, 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  command = [[setlocal expandtab tabstop=2 shiftwidth=2]],
})

-- use soft tabs, 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "hcl" },
  command = [[setlocal expandtab tabstop=2 shiftwidth=2]],
})

-- use soft tabs, 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript" },
  command = [[setlocal expandtab tabstop=2 shiftwidth=2]],
})

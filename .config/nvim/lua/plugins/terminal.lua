return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {},
  },
  {
    "chomosuke/term-edit.nvim",
    lazy = "toggleterm", -- or ft = 'toggleterm' if you use toggleterm.nvim
    version = "1.*",
    opts = {
      -- Mandatory option:
      -- Set this to a lua pattern that would match the end of your prompt.
      -- Or a table of multiple lua patterns where at least one would match the
      -- end of your prompt at any given time.
      -- For most bash/zsh user this is '%$ '.
      -- For most powershell/fish user this is '> '.
      -- For most windows cmd user this is '>'.
      prompt_end = "%$ ",
      -- How to write lua patterns: https://www.lua.org/pil/20.2.html
    },
  },
}

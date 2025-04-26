return {
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      lsp = { auto_attach = true },
      highlight = true,
    },
  },
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
    opts = {
      window = {
        size = { height = "40%", width = "100%" },
        position = { row = "100%", col = "50%" },
      },
      lsp = {
        auto_attach = true,
      },
    },
  },
}

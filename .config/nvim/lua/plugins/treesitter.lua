return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
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
          "rust",
          "diff",
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    opts = {
      chunk = { enable = true },
      indent = { enable = true },
    },
  },
}

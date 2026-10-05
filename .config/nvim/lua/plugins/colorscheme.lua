return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true,
    styles = {
      comments = { italic = true },
    },
    on_highlights = function(highlights, colors)
      highlights.Comment = {
        fg = "#777ea0",
        italic = true,
      }
    end,
  },
}

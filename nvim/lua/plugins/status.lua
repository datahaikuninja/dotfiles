return {
  { "j-hui/fidget.nvim",           opts = {} },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sections = {
        lualine_a = {},
        lualine_b = { "branch", "diagnostics" },
        lualine_c = {
          "filename",
          {
            "navic",
            color_correction = nil,
            navic_opts = nil,
          },
        },
        lualine_x = { "Filetype" },
        lualine_y = {},
        lualine_z = {},
      },
      options = {
        section_separators = "",
        globalstatus = false,
      },
    },
  },
  { "alvarosevilla95/luatab.nvim", opts = {} },
  {
    "mvllow/modes.nvim",
    tag = "v0.2.0",
    opts = {
      colors = {
        copy = "#D3B461",
        delete = "#BB385A",
        insert = "#6FA589",
        visual = "#8A5FCC",
      },
      line_opacity = 0.3,
      set_cursor = true,
      set_cursorline = true,
      set_number = true,
      ignore_filetypes = { "NvimTree", "TelescopePrompt" },
    },
  },
}

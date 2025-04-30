return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    opts = function(_, opts)
      local base_opts = {
        opts = {
          language = "Japanese",
        },
        display = {
          chat = {
            auto_scroll = false,
            show_header_separator = true,
          },
        },
      }
      local env_opts = require("envs.code-companion").opts
      return vim.tbl_deep_extend("force", opts, base_opts, env_opts)
    end,
    init = function()
      require("plugins.codecompanion.fidget-spinner"):init()
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = false,
      },
      filetypes = {
        "yaml",
        "markdown",
        "gitcommit",
      },
    },
  },
  { "zbirenbaum/copilot-cmp", opts = {} },
}

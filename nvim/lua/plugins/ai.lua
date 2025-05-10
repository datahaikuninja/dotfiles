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
          -- https://codecompanion.olimorris.dev/configuration/action-palette.html#layout
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",                   -- Prompt used for interactive LLM calls
            provider = "snacks",                  -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
            opts = {
              show_default_actions = true,        -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            },
          },
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

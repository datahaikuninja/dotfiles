return {
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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",
    config = function()
      require("CopilotChat").setup({
        debug = true,
        window = {
          layout = "float",
          width = 0.9,
          height = 0.9,
          border = "rounded",
        },
      })

      -- Quick chat with your buffer
      function CopilotChatBuffer()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end

      vim.keymap.set("n", "<leader>ccq", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })

      -- display a prompt to the user to select an action from a list of available actions in Copilot Chat.
      function ShowCopilotChatActionPrompt()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      end

      vim.keymap.set(
        "n",
        "<leader>ccp",
        "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
        { noremap = true, silent = true }
      )

      function ShowCopilotChatHelpPrompt()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.help_actions())
      end

      vim.keymap.set("n", "<leader>cch", "<cmd>lua ShowCopilotChatHelpPrompt()<cr>", { noremap = true, silent = true })

      vim.keymap.set("n", "<leader>cct", "<cmd>CopilotChatToggle<cr>", { noremap = true, silent = true })
    end,
  },
}

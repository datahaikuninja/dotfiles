if os.getenv("WORK_ENV") == "private" then
  return {
    opts = {
      interactions = {
        chat = {
          adapter = "gemini",
          roles = {
            llm = function(adapter)
              return "󱇶 CodeCompanion (" .. adapter.formatted_name .. ")"
            end,
            user = " Me",
          },
        },
        inline = {
          adapter = "gemini",
        },
      },
      adapters = {
        -- Starting around December 2025, I'm frequently getting 429 errors when sending requests to gemini-2.0-flash-lite in the Code Companion chat.
        -- So, I use Gemini-CLI instead of codecompanion,nvim for private development.
        http = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.0-flash-lite",
                },
              },
              env = {
                api_key = "cmd: cat /Users/takashina.jundai/gemini/api_key.txt | xargs echo -n",
              },
            })
          end,
        },
      },
    },
  }
elseif os.getenv("WORK_ENV") == "work" then
  return {
    opts = {
      interactions = {
        chat = {
          adapter = "copilot",
          roles = {
            llm = function(adapter)
              return " CodeCompanion (" .. adapter.formatted_name .. ")"
            end,
            user = " Me",
          },
        },
        inline = {
          adapter = "copilot",
        },
      },
      adapters = {
        http = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4",
                },
              },
            })
          end,
        },
      },
    },
  }
else
  return {
    opts = {},
  }
end

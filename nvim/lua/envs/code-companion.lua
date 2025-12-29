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
        -- this aapter doesn't work after "codecompanion.nvim": { "branch": "main", "commit": "ff3eae6630a019e42c4b113270109000f7ff624e" }
        -- So, I use Gemini-CLI instead of codecompanion,nvim for private development.
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
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.7-sonnet",
              },
            },
          })
        end,
      },
    },
  }
else
  return {
    opts = {},
  }
end

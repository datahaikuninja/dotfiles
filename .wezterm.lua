-- Pull in the wezterm API
local wezterm = require("wezterm")

local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- favorite color_scheme:
-- 'Green Screen (base16)'
-- 'Catch Me If You Can (terminal.sexy)'
-- 'ForestBlue'
-- 'IC_Green_PPL'
-- 'Night Owl (Gogh)'

-- enable IME in wezterm
config.use_ime = true

-- set color scheem
config.color_scheme = "Tokyo Night"

-- put tab bar at bottom
config.tab_bar_at_bottom = false

-- Window transparency
config.window_background_opacity = 1.0

-- fonts
config.font = wezterm.font_with_fallback({
  {
    --family = "JetBrains Mono",
    family = "Berkeley Mono",
    -- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
    weight = "Regular",
    -- stretch = "Normal",
    -- style = "Normal",
  },
  {
    family = "HackGen",
    weight = "Regular",
  },
})

-- font_size
config.font_size = 14.0

-- leader key
config.leader = { key = "/", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  {
    key = "p",
    mods = "LEADER",
    action = act.PaneSelect,
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action({ SendString = "\x1b\r" }),
  },
  {
    mods = "LEADER",
    key = ",",
    action = act.PromptInputLine({
      description = "Wezterm: set tab title",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = "%",
    mods = "LEADER",
    action = act.SplitHorizontal({}),
  },
  {
    key = '"',
    mods = "LEADER",
    action = act.SplitVertical({}),
  },
  --workspace
  {
    -- Create new workspace
    mods = "LEADER",
    key = "c",
    action = act.PromptInputLine({
      description = "(wezterm) Create new workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    -- switch workspace
    key = "s",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      -- create workspace list
      local workspaces = {}
      for i, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, {
          id = name,
          label = string.format("%d: %s", i, name),
        })
      end
      local current = wezterm.mux.get_active_workspace()
      -- raunch selection dialog
      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(_, _, id, label)
            if not id and not label then
              wezterm.log_info("Workspace selection canceled")
            else
              window:perform_action(act.SwitchToWorkspace({ name = id }), pane) --switch to workspace
            end
          end),
          title = "Select workspace",
          choices = workspaces,
          fuzzy = true,
          fuzzy_description = string.format("Select workspace: %s -> ", current),
        }),
        pane
      )
    end),
  },
  {
    key = "$",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Wezterm: set workspace title",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
}

--config.status_update_interval = 1000
wezterm.on("update-status", function(window, pane)
  -- Each element holds that text for a cell in a "powerline" style << fade
  local cells = {}

  -- current working directory
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path -- see: https://wezfurlong.org/wezterm/config/lua/wezterm.url/Url.html
    table.insert(cells, cwd)
  end

  -- workspace name
  local work_space = window:active_workspace()
  table.insert(cells, work_space)

  -- date/time: e.g.) "Wed Mar 3 08:14"
  local date = wezterm.strftime("%a %b %-d %H:%M")
  table.insert(cells, date)

  -- An Entry for each battery (typically 0 or 1 battery)
  local BATTERY = utf8.char(0xf240)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format(BATTERY .. " %.0f%%", b.state_of_charge * 100))
  end

  -- The powerline < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the background of each cell
  local colors = {
    "#3c1361",
    "#52307c",
    "#663a82",
    "#7c5295",
    "#b491c8",
  }

  -- Forground color for the text across the fade
  local text_fg = "#c0c0c0"

  -- the elements to be formatted
  local elements = {}

  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = " " .. text .. " " })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

-- and finally, return the configuration to wezterm
return config

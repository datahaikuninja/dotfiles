-- Pull in the wezterm API
local wezterm = require 'wezterm'

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

config = {
  color_scheme = 'tokyonight_storm',
  tab_bar_at_bottom = true,
  window_background_opacity = 0.8,
  font = wezterm.font('JetBrains Mono', {weight="Bold", stretch="Normal", style="Normal"}),
  font_size = 10.0,
  keys = {
    {
      key = 'p',
      mods = 'CTRL|SHIFT',
      action = act.PaneSelect,
    },
  },
}

-- and finally, return the configuration to wezterm
return config


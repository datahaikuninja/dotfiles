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

-- enable IME in wezterm
config.use_ime = true

-- set color scheem
config.color_scheme = 'nightfox'

-- put tab bar at bottom
config.tab_bar_at_bottom = true

-- Window transparency
config.window_background_opacity = 0.9

-- fonts
config.font = wezterm.font_with_fallback {
    {
        family = 'JetBrains Mono',
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
        weight = "Medium",
        stretch = "Normal",
        style = "Normal",
    },
   "HackGen35ConsoleNF-Bold",
}

-- font_size
config.font_size = 20.0

-- key mappings
config.keys = {
    {
        key = 'p',
        mods = 'CTRL|SHIFT',
        action = act.PaneSelect,
    }
}

-- and finally, return the configuration to wezterm
return config


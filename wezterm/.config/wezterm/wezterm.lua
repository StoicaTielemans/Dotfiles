-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- wayland settings
config.enable_wayland = false

-- font settings
config.font_size = 12.5
config.line_height = 1.2
config.font = wezterm.font("JetBrains Mono")
-- disable ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- color settings
--config.color_scheme = "Tokyo Night"
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	cursor_bg = "#f5c2e7",
	cursor_border = "#f5c2e7",
}
--padding removed==>
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Appearance settings
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

--config.tab_bar_at_bottom = true

-- misc settings
config.max_fps = 120
config.prefer_egl = true

-- startup program
config.default_prog = { "/bin/zsh", "-c", "fastfetch --load-config neofetch.jsonc; exec zsh" }

-- and finally, return the configuration to wezterm
return config

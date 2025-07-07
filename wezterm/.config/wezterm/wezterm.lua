-- Pull in the wezterm API
local wezterm = require("wezterm")
-- Use config builder
local config = wezterm.config_builder()

-- === Wayland settings ===
config.enable_wayland = true
config.prefer_egl = true

-- === Clipboard settings ===
-- Remove these invalid options:
-- config.copy_mode_copy_to_clipboard = true
-- config.paste_from_clipboard = true

config.keys = {
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

-- === Mouse bindings for clipboard ===
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 2, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 3, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
}

-- === Font ===
config.font_size = 12.5
config.line_height = 1.2
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- === Colors ===
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	cursor_bg = "#f5c2e7",
	cursor_border = "#f5c2e7",
}

-- === Padding and Appearance ===
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_opacity = 0.9
config.window_decorations = "NONE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- === Performance ===
config.max_fps = 120

-- === Startup ===
config.default_prog = { "/bin/zsh", "-c", "fastfetch --load-config neofetch.jsonc; exec zsh" }

-- Return config
return config

-- ~/.config/wezterm/wezterm.lua

-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- === Detect Distro ===
local function detect_distro()
	local f = io.open("/etc/os-release", "r")
	if not f then
		return "unknown"
	end
	local content = f:read("*all")
	f:close()

	if content:match("Arch Linux") then
		return "arch"
	elseif content:match("NixOS") then
		return "nixos"
	else
		return "unknown"
	end
end

-- === Choose shell path based on distro ===
local distro = detect_distro()
if distro == "arch" then
	config.default_prog = { "/bin/zsh", "-c", "fastfetch --config neofetch.jsonc;dstask; exec zsh" }
elseif distro == "nixos" then
	config.default_prog = { "/run/current-system/sw/bin/zsh", "-c", "fastfetch --config neofetch.jsonc; exec zsh" }
else
	config.default_prog = { "bash" }
end

-- === Wayland settings ===
config.enable_wayland = true

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
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = 0.9
config.window_decorations = "NONE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- === Performance ===
config.max_fps = 120

-- Return config
return config

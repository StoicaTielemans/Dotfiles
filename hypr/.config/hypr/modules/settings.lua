local settings = {
	terminal = "alacritty",
	fileManager = "nemo",
	menu = "rofi -show drun",
	browser = "helium-browser",
	chat = "vesktop",
	logout = "wlogout",
}
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "catppuccin-mocha-lavender-standard+default")

return settings

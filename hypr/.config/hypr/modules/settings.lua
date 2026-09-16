local settings = {
  terminal = "ghostty",
  fileManager = "ghostty -e zsh -i -c 'y; exec zsh'",
  menu = "rofi -show drun",
  browser = "helium-browser",
  chat = "discord",
  logout = "pkill -SIGUSR1 -x customBar",
  bar = "~/Code/github.com/StoicaTielemans/StickBar/build/stickBar",
  -- logout = "wlogout",
}
-- chat = "flatpak run com.discordapp.Discord",
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_USE_PORTAL", "1")
hl.env("GTK_THEME", "catppuccin-mocha-lavender-standard+default")
hl.env("PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES", "1")

return settings

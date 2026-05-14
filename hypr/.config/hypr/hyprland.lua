---- MY PROGRAMS AND ENVIRONMENT VARIABLES ----
require("modules/settings")
---- MONITORS ----
require("modules/monitors")
---- AUTOSTART ----
require("modules/autoStart")
----- PERMISSIONS -----
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

---- LOOK AND FEEL ----
require("modules/style")
---- INPUT ----
require("modules/input")
---- WINDOWS AND WORKSPACES ----
require("modules/windowsWorkspaces")

---- KEYBINDINGS ----
require("modules/keybinds")

--- list of software ---
-- rofi wayland (sherlock)
-- hyprpaper (old)  new wpaperd (old) awwww background
-- kitty (old) new ghostty
-- grim / slurp / wayfreeze / wl-copy
-- nemo
-- cliphist wl-paste
-- waybar
-- notifications swaync

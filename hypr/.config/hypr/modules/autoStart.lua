local settings = require("modules/settings")
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
	hl.exec_cmd(settings.terminal)
	-- blue light filter
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("waybar")
	-- gtk theme
	hl.exec_cmd("xsettingsd &")
	-- equalizer
	hl.exec_cmd("easyeffects --gapplication-service -l My")
	-- background
	hl.exec_cmd("awww-daemon & sleep 1 && ~/.config/hypr/scripts/awww_background.sh ~/Pictures/Background")
	-- authentication agent
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
	-- remap for shifter to make that work
	hl.exec_cmd("python3 ~/Documents/shifter_uinput.py")
	-- clipboard deamon
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

local settings = require("modules/settings")
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(settings.terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(settings.fileManager))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(settings.browser))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(settings.chat))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(settings.menu))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd(settings.logout))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- bluescreen filter
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprsunset_pause.sh"))
hl.bind(mainMod .. "+ SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprsunset_toggle_2500k.sh"))

-- screenshot
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/imgToText.sh"))
hl.bind("PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/grimblast.sh --freeze --notify copy area"))
hl.bind(mainMod .. "+ PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/grimblast.sh --freeze --notify copysave area"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/imgToText.sh"))

-- screen toggles
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. "+ SHIFT + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenMouseLock.sh"))

-- Move focus with mainMod + arrow keys or hjkl
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- Switch workspaces alternavtive with mainMod + [0-9]
local bindings = {
	["1"] = 6,
	["2"] = 7,
	["3"] = 8,
	["4"] = 9,
	["5"] = 0,
}
for key, ws in pairs(bindings) do
	hl.bind(mainMod .. "+ CTRL + " .. key, hl.dsp.focus({ workspace = ws }))
	hl.bind(mainMod .. "+ CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---------------------------------------------------------
-- Laptop multimedia keys for volume and LCD brightness--
---------------------------------------------------------

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Not used keybinds
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

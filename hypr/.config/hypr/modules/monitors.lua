-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-2",
	mode = "1920x1080@165",
	position = "0x0",
	scale = 1,
})
hl.monitor({
	output = "HDMI-A-2",
	mode = "1920x1080@144",
	position = "1920x0",
	scale = "auto",
})
hl.monitor({
	output = "DP-3",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
	mirror = "DP-2",
})

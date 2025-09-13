-- ~/.config/yazi/init.lua
-- plugin relative-motions Note
-- The show_numbers and show_motion functionalities overwrite Current:redraw and Status:children_redraw respectively.
-- If you have custom implementations for any of this functions you can add the provided Entity:number and Status:motion
-- to your implementations, just check here how we are doing things.
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })
-- plugin recycle-bin
require("recycle-bin"):setup()

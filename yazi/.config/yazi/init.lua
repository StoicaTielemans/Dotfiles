-- ~/.config/yazi/init.lua

-- custom linemode: shows both file size and rwx permissions on the
-- right of each entry (set `linemode = "size_perm"` in yazi.toml)
function Linemode:size_perm()
	local size = self._file:size()
	local size_str = size and ya.readable_size(size) or "-"

	local perm = self._file.cha:perm() or ""

	return string.format("%s %s", perm, size_str)
end

-- plugin relative-motions Note
-- The show_numbers and show_motion functionalities overwrite Current:redraw and Status:children_redraw respectively.
-- If you have custom implementations for any of this functions you can add the provided Entity:number and Status:motion
-- to your implementations, just check here how we are doing things.
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })
-- plugin recycle-bin
require("recycle-bin"):setup()
-- git inline
require("git"):setup()
-- plugin bookmarks (m = save, ' = jump, b d = delete, b D = delete all)
require("bookmarks"):setup({ persist = "all", notify = { enable = true } })

-- zoxide: record every directory visited inside yazi, not just the one
-- you quit on (the `y()` shell wrapper only handles that last one)
ps.sub("cd", function()
	local cwd = cx.active.current.cwd
	ya.async(function() Command("zoxide"):arg({ "add", tostring(cwd) }):status() end)
end)

-- ~/.config/yay/init.lua
-- Tracks AUR package maintainers across sessions.
-- On every install/upgrade it:
--   1. Detects if the maintainer changed since last seen
--   2. Warns you and asks to confirm before continuing
--   3. Saves the new maintainer to disk
--   4. At the end of each run, prints a full list of all known maintainers
--
-- State file: ~/.config/yay/maintainer_db.txt
-- Format (one entry per line):  pkgbase=maintainer

-- ─── Config ──────────────────────────────────────────────────────────────────

local DB_PATH = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/yay/maintainer_db.txt"

-- ─── DB helpers ──────────────────────────────────────────────────────────────

local function load_db()
  local db = {}
  local f = io.open(DB_PATH, "r")
  if not f then
    return db
  end
  for line in f:lines() do
    local pkg, maint = line:match("^([^=]+)=(.*)$")
    if pkg then
      db[pkg] = maint
    end
  end
  f:close()
  return db
end

local function save_db(db)
  local f = io.open(DB_PATH, "w")
  if not f then
    yay.log.warn("maintainer_tracker: could not write to " .. DB_PATH)
    return
  end
  -- Sort keys so the file is human-readable
  local keys = {}
  for k in pairs(db) do
    table.insert(keys, k)
  end
  table.sort(keys)
  for _, k in ipairs(keys) do
    f:write(k .. "=" .. db[k] .. "\n")
  end
  f:close()
end

-- ─── Shared state (lives for the duration of one yay run) ────────────────────

local db = load_db()
local changed_pkgs = {} -- { { base, old, new }, ... }  — populated by hooks
local seen_this_run = {} -- pkgbase → maintainer for packages touched this run

-- ─── Helpers ─────────────────────────────────────────────────────────────────

-- The AUR RPC sometimes returns no maintainer even when one exists (cache lag,
-- recent adoption). Fall back to parsing the "# Maintainer:" comment line that
-- AUR contributors put at the top of every PKGBUILD by convention.
local function pkgbuild_maintainer(pkgbuild_text)
  -- Matches:  # Maintainer: Some Name <email>
  --       or: # Maintainer: Some Name (handle)
  local name = pkgbuild_text:match("^%s*#%s*[Mm]aintainer%s*:%s*(.-)%s*\n")
  if name and name ~= "" then
    return name
  end
  return nil
end

-- ─── AURPreInstall: catch maintainer changes before any build work ───────────

yay.create_autocmd("AURPreInstall", {
  desc = "warn if AUR package maintainer changed since last seen",
  callback = function(event)
    local base = event.match
    local maintainer = event.data.maintainer or ""

    -- RPC may lag; fall back to parsing the PKGBUILD comment header
    if maintainer == "" then
      maintainer = pkgbuild_maintainer(event.data.pkgbuild or "") or ""
    end

    -- Still nothing — genuinely orphaned or unknown
    if maintainer == "" then
      yay.log.warn("[maintainer_tracker] " .. base .. ": no maintainer found (orphaned or RPC lag)")
      seen_this_run[base] = "(unknown)"
      return
    end

    seen_this_run[base] = maintainer

    local known = db[base]
    if known == nil then
      -- First time we see this package — just record it
      yay.log.info("[maintainer_tracker] " .. base .. ": first install, maintainer is '" .. maintainer .. "'")
    elseif known ~= maintainer then
      -- Maintainer changed!
      table.insert(changed_pkgs, { base = base, old = known, new = maintainer })

      -- Print a very visible warning
      print("")
      print(
        "┌─────────────────────────────────────────────────────┐"
      )
      print("│  ⚠  MAINTAINER CHANGE DETECTED                      │")
      print("│                                                      │")
      print("│  Package  : " .. base)
      print("│  Was      : " .. known)
      print("│  Now      : " .. maintainer)
      print("│                                                      │")
      print("│  Review the PKGBUILD carefully before continuing!   │")
      print(
        "└─────────────────────────────────────────────────────┘"
      )
      print("")
      io.write("Continue installing " .. base .. "? [y/N] ")
      io.flush()
      local answer = io.read("*l") or ""
      if answer:lower() ~= "y" then
        yay.abort(base .. ": aborted by user after maintainer change")
      end
    end
    -- else: maintainer unchanged, silent
  end,
})

-- ─── UpgradeSelect: also check maintainer changes during -Syu ────────────────

yay.create_autocmd("UpgradeSelect", {
  desc = "flag AUR upgrades where the maintainer changed",
  callback = function(event)
    for _, pkg in ipairs(event.data.upgrades) do
      if pkg.repository == "aur" and pkg.maintainer ~= "" then
        local known = db[pkg.base] or db[pkg.name]
        if known ~= nil and known ~= pkg.maintainer then
          print("")
          print(
            "⚠  [maintainer_tracker] UPGRADE: "
              .. pkg.name
              .. " maintainer changed from '"
              .. known
              .. "' → '"
              .. pkg.maintainer
              .. "'"
          )
          print("   Consider reviewing before upgrading.")
        end
      end
    end
    return { exclude = {} }
  end,
})

-- ─── PostInstall: persist new maintainers + print full list ──────────────────

yay.create_autocmd("PostInstall", {
  desc = "save updated maintainers and print the full maintainer list",
  callback = function(_event)
    -- Merge this run's data into the DB
    for base, maint in pairs(seen_this_run) do
      db[base] = maint
    end
    save_db(db)

    -- ── Summary of changes this run ───────────────────────────────────
    if #changed_pkgs > 0 then
      print("")
      print(
        "═══════════════════════════════════════════════════════"
      )
      print(" ⚠  MAINTAINER CHANGES THIS SESSION")
      print(
        "═══════════════════════════════════════════════════════"
      )
      for _, c in ipairs(changed_pkgs) do
        print(string.format("  %-30s  %s  →  %s", c.base, c.old, c.new))
      end
      print(
        "═══════════════════════════════════════════════════════"
      )
    end

    -- ── Full maintainer list ──────────────────────────────────────────
    local keys = {}
    for k in pairs(db) do
      table.insert(keys, k)
    end
    table.sort(keys)

    if #keys == 0 then
      return
    end

    print("")
    print(
      "═══════════════════════════════════════════════════════"
    )
    print(" AUR PACKAGE MAINTAINERS  (" .. #keys .. " packages tracked)")
    print(
      "═══════════════════════════════════════════════════════"
    )
    print(string.format("  %-35s  %s", "PACKAGE", "MAINTAINER"))
    print("  " .. string.rep("─", 60))
    for _, k in ipairs(keys) do
      print(string.format("  %-35s  %s", k, db[k]))
    end
    print(
      "═══════════════════════════════════════════════════════"
    )
  end,
})

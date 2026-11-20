-- Rex config, migrated from tmux (~/.config/tmux), zellij (~/.config/zellij/config.kdl),
-- Ghostty (~/.config/ghostty/config) and herdr's default keymap (on the ` prefix).

---------------------------------------------------------------------------
-- Hosts: other Rex servers, offered by "New Session on Host…" (` shift+n).
---------------------------------------------------------------------------
rex.host{ label = "linux", endpoint = "ssh://vinuka@10.10.0.1" }

---------------------------------------------------------------------------
-- cmd+k clears the terminal, as in Terminal.app, iTerm2 and Ghostty.
-- The session picker (Rex's default on cmd+k) moves to shift+cmd+k.
---------------------------------------------------------------------------
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("shift+cmd+k", "session.switch")

---------------------------------------------------------------------------
-- tmux: prefix is ` (backtick), shared with herdr's keys (below). Where the
-- two disagreed, herdr won; these are the tmux keys herdr doesn't use.
---------------------------------------------------------------------------
-- ` ` types a literal backtick, since ` alone now only starts a sequence.
rex.bind("`>`", "pane.send_key", { key = "`" })

rex.bind("`>shift+c", "client.tab.new")
rex.bind("`>'", "session.switch")
rex.bind("`>o", "session.switch")
rex.bind("`>shift+\\", "pane.split", { direction = "down" })
rex.bind("`>q", "client.tab.close")

-- bind -r: ` ctrl+r enters a repeat mode; enter or escape leaves it.
rex.mode("repeat", { exclusive = true })
rex.bind("`>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")
rex.bind("`>,", "pane.resize", { amount = 20, direction = "left" })
rex.bind("repeat/,", "pane.resize", { amount = 20, direction = "left" })
rex.bind("`>.", "pane.resize", { amount = 20, direction = "right" })
rex.bind("repeat/.", "pane.resize", { amount = 20, direction = "right" })
rex.bind("repeat/-", "pane.resize", { amount = 7, direction = "down" })
rex.bind("`>=", "pane.resize", { amount = 7, direction = "up" })
rex.bind("repeat/=", "pane.resize", { amount = 7, direction = "up" })

rex.bind("alt+h", "pane.focus", { direction = "left" })
rex.bind("alt+j", "pane.focus", { direction = "down" })
rex.bind("alt+k", "pane.focus", { direction = "up" })
rex.bind("alt+l", "pane.focus", { direction = "right" })

---------------------------------------------------------------------------
-- Ghostty
---------------------------------------------------------------------------
-- The ctrl+b> sequences are not migrated; ` is the prefix (tmux and herdr).
rex.bind("ctrl+shift+t", "client.tab.new")
rex.bind("ctrl+shift+h", "client.tab.previous")
rex.bind("ctrl+shift+l", "client.tab.next")

---------------------------------------------------------------------------
-- zellij: normal mode is Rex with no mode active; pane, resize, move and tab
-- are exclusive Rex modes. Locked, scroll, search, session and the rename
-- modes are not migrated, and nor is the tmux mode (ctrl+b): the ` prefix
-- covers it.
---------------------------------------------------------------------------

-- Runs an action, then leaves every mode (zellij's `SwitchToMode "Normal"`).
rex.action{
  name  = "then_normal",
  title = "Run an action and return to normal mode",
  args  = { action = "string", args = "object?" },
  run   = function(ctx, args)
    rex.client.queue(args.action, args.args or {})
    rex.client.queue("client.mode.exit_all")
  end,
}

local MODES = { "pane", "resize", "move", "tab" }

-- Binds key to action in each of the given modes.
local function bind_in(modes, key, action, args)
  for _, mode in ipairs(modes) do
    rex.bind(mode .. "/" .. key, action, args)
  end
end

-- Every zellij mode in MODES except `skip` (a shared_except block).
local function except(skip)
  local modes = {}
  for _, mode in ipairs(MODES) do
    if mode ~= skip then table.insert(modes, mode) end
  end
  return modes
end

for _, mode in ipairs(MODES) do
  rex.mode(mode, { exclusive = true })
end

-- normal { } (alt+h/j/k/l come from tmux above)
rex.bind("alt+n", "client.tab.new")
rex.bind("alt+c", "client.tab.new")
rex.bind("alt+x", "client.tab.close")
for i = 1, 9 do
  rex.bind("alt+" .. i, "client.tab.goto", { index = i })
end
rex.bind("alt+right", "pane.split", { direction = "right" })
rex.bind("alt+left", "pane.split", { direction = "left" })
rex.bind("alt+down", "pane.split", { direction = "down" })
rex.bind("alt+up", "pane.split", { direction = "up" })
rex.bind("alt+r", "client.tab.rename")
rex.bind("alt+f", "pane.zoom")

-- Keys that enter a mode, from normal and from every other mode
-- (shared_except "<mode>" "locked").
local ENTRY = { pane = "ctrl+p", resize = "ctrl+n", tab = "ctrl+t", move = "ctrl+h" }
for mode, key in pairs(ENTRY) do
  rex.bind(key, "client.mode.enter", { name = mode })
  bind_in(except(mode), key, "client.mode.enter", { name = mode })
end

-- shared_except "locked" and shared_except "normal" "locked"
bind_in(MODES, "alt+n", "pane.split", { direction = "auto" })
for _, dir in ipairs({ "left", "right", "down", "up" }) do
  bind_in(MODES, "alt+" .. dir, "pane.focus", { direction = dir })
end
bind_in(MODES, "alt+h", "pane.focus", { direction = "left" })
bind_in(MODES, "alt+l", "pane.focus", { direction = "right" })
bind_in(MODES, "alt+j", "pane.focus", { direction = "down" })
bind_in(MODES, "alt+k", "pane.focus", { direction = "up" })
bind_in(MODES, "enter", "client.mode.exit_all")
bind_in(MODES, "escape", "client.mode.exit_all")

-- Vim keys and arrows, as zellij binds "h" "Left" and so on together.
local DIRS = { h = "left", left = "left", j = "down", down = "down", k = "up", up = "up", l = "right", right = "right" }

-- pane { }
rex.bind("pane/ctrl+p", "client.mode.exit_all")
for key, dir in pairs(DIRS) do
  rex.bind("pane/" .. key, "pane.focus", { direction = dir })
end
rex.bind("pane/p", "pane.focus_next")
rex.bind("pane/n", "then_normal", { action = "pane.split", args = { direction = "auto" } })
rex.bind("pane/d", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("pane/r", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("pane/x", "then_normal", { action = "pane.close" })
rex.bind("pane/f", "then_normal", { action = "pane.zoom" })
rex.bind("pane/c", "then_normal", { action = "pane.rename" })

-- resize { }
rex.bind("resize/ctrl+r", "client.mode.exit_all")
for key, dir in pairs(DIRS) do
  rex.bind("resize/" .. key, "pane.resize", { direction = dir })
end

-- move { }
rex.bind("move/ctrl+m", "client.mode.exit_all")
for key, dir in pairs(DIRS) do
  rex.bind("move/" .. key, "pane.move", { direction = dir })
end

-- tab { }
rex.bind("tab/ctrl+t", "client.mode.exit_all")
rex.bind("tab/r", "then_normal", { action = "client.tab.rename" })
for _, key in ipairs({ "h", "left", "up", "k" }) do
  rex.bind("tab/" .. key, "client.tab.previous")
end
for _, key in ipairs({ "l", "right", "down", "j" }) do
  rex.bind("tab/" .. key, "client.tab.next")
end
rex.bind("tab/n", "then_normal", { action = "client.tab.new" })
rex.bind("tab/x", "then_normal", { action = "client.tab.close" })
for i = 1, 9 do
  rex.bind("tab/" .. i, "then_normal", { action = "client.tab.goto", args = { index = i } })
end

---------------------------------------------------------------------------
-- herdr: default [keys], with ` in place of herdr's ctrl+b prefix. herdr
-- workspaces are Rex sessions, tabs are tabs and panes are panes. Not
-- ported, for lack of a Rex equivalent: detach (q), open_notification_target
-- (o), new_worktree (shift+g) and edit_scrollback (e). ` q (close tab) and
-- ` o (session picker) are bound above instead.
---------------------------------------------------------------------------
-- The leader key, as a sequence prefix: LEADER .. "g" is "`>g".
local LEADER = "`>"

-- General
rex.bind(LEADER .. "shift+/", "client.palette.toggle") -- help (?)
rex.bind(LEADER .. "space", "client.palette.toggle")
rex.bind(LEADER .. "s", "client.settings")
rex.bind(LEADER .. "shift+r", "client.config.reload")
rex.bind(LEADER .. "b", "client.sidebar.toggle")

-- Workspaces -> sessions
-- Asks which host (this Mac or linux) the new session runs on.
rex.bind(LEADER .. "shift+n", "session.new.on_host")
rex.bind(LEADER .. "shift+w", "session.rename")
rex.bind(LEADER .. "shift+d", "session.close")
rex.bind(LEADER .. "g", "session.switch") -- goto picker
rex.bind(LEADER .. "w", "client.mode.enter", { name = "navigate" })

-- Tabs
rex.bind(LEADER .. "c", "client.tab.new")
rex.bind(LEADER .. "shift+t", "client.tab.rename")
rex.bind(LEADER .. "p", "client.tab.previous")
rex.bind(LEADER .. "n", "client.tab.next")
rex.bind(LEADER .. "shift+x", "client.tab.close")
for i = 1, 9 do
  rex.bind(LEADER .. i, "client.tab.goto", { index = i })
end

-- Panes
rex.bind(LEADER .. "v", "pane.split", { direction = "right" })
rex.bind(LEADER .. "-", "pane.split", { direction = "down" })
rex.bind(LEADER .. "x", "pane.close")
rex.bind(LEADER .. "z", "pane.zoom")
rex.bind(LEADER .. "shift+p", "pane.rename")
rex.bind(LEADER .. "[", "pane.copy_mode.enter")
rex.bind(LEADER .. "tab", "pane.focus_next")
rex.bind(LEADER .. "shift+tab", "pane.focus_previous")
-- herdr swaps panes on shift+h/j/k/l; Rex's pane.move is the closest match.
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind(LEADER .. key, "pane.focus", { direction = dir })
  rex.bind(LEADER .. "shift+" .. key, "pane.move", { direction = dir })
end
-- Not herdr, whose ` r is resize mode: renames the tab, as tmux's ` r did.
-- Resize with zellij's ctrl+n mode or ` ctrl+r instead.
rex.bind(LEADER .. "r", "client.tab.rename")

-- navigate { }: up/down walk sessions (herdr's workspace list), h/j/k/l and
-- left/right move pane focus, escape or enter leaves.
rex.mode("navigate", { exclusive = true })
rex.bind("navigate/up", "session.previous")
rex.bind("navigate/down", "session.next")
for key, dir in pairs({ h = "left", left = "left", j = "down", k = "up", l = "right", right = "right" }) do
  rex.bind("navigate/" .. key, "pane.focus", { direction = dir })
end
rex.bind("navigate/escape", "client.mode.exit")
rex.bind("navigate/ctrl+[", "client.mode.exit")
rex.bind("navigate/enter", "client.mode.exit")

---------------------------------------------------------------------------
-- Port forwards: Rex can start a forward from the palette ("Forward Port…")
-- but not stop one. Every forward is a tunnel block, so this lists the
-- tunnel blocks in every session on this Mac and on each host, and closes
-- the one picked.
---------------------------------------------------------------------------
local TUNNEL = "com.superlogical.tunnel"

-- This Mac's server, then one entry per saved host. Hosts that share an
-- endpoint are the same server, so only the first of them is kept.
local function forward_servers()
  local servers = { { label = "this Mac", api = rex } }
  local hosts = rex.call("hosts.list", {})
  local seen = {}
  for _, host in ipairs(hosts and hosts.hosts or {}) do
    local endpoint = host.endpoints and host.endpoints[1]
    if endpoint and not seen[endpoint] then
      seen[endpoint] = true
      table.insert(servers, { label = host.label, api = rex.server(host.label) })
    end
  end
  return servers
end

-- Every tunnel block, with the server and session it lives in and what its
-- info method reports (the local and remote ends of the forward).
local function list_forwards()
  local found = {}
  for _, server in ipairs(forward_servers()) do
    local list, err = server.api.call("session.list", {})
    if list == nil then
      rex.log("warn", "stop_port_forward: " .. server.label .. ": " .. tostring(err))
    else
      for _, session in ipairs(list.sessions or {}) do
        local res = server.api.session.list_blocks{ session_id = session.session_id }
        for _, block in ipairs(res and res.blocks or {}) do
          if block.creator_name == TUNNEL then
            local info = server.api.block.call(TUNNEL, "info", {
              session_id = session.session_id,
              block_id   = block.block_id,
            }) or {}
            table.insert(found, { server = server, session = session, block = block, info = info })
          end
        end
      end
    end
  end
  return found
end

-- "127.0.0.1:65277 → 127.0.0.1:22": where the forward listens, then where
-- it connects. A dial tunnel connects from the server and a listen tunnel
-- listens on it, so the two read their ends from different fields.
local function describe_forward(info)
  local from, to
  if info.flavor == "listen" then
    from, to = info.address, info.client_target
  else
    from, to = info.client_address, info.target
  end
  if from and to then return from .. " → " .. to end
end

rex.action{
  name     = "stop_port_forward",
  title    = "Stop Port Forward…",
  category = "Host",
  keywords = "port forward forwarding tunnel close stop kill end",
  run      = function(ctx, args)
    local forwards = list_forwards()
    if #forwards == 0 then error("No port forwards are open", 0) end

    local items = {}
    for i, f in ipairs(forwards) do
      table.insert(items, {
        id       = tostring(i),
        title    = describe_forward(f.info) or f.block.label,
        subtitle = f.server.label .. " · " .. (f.session.label or f.session.session_id),
        detail   = (f.info.connections or 0) .. " conn",
        icon     = "link",
      })
    end

    local picked = rex.ui.pick{
      title       = "Stop port forward",
      placeholder = "Filter forwards",
      confirm     = "Stop forward",
      items       = items,
    }
    if picked == nil then return end

    local f = forwards[tonumber(picked)]
    local _, err = f.server.api.call("block.close", {
      session_id = f.session.session_id,
      block_id   = f.block.block_id,
    })
    if err ~= nil then error(err, 0) end
  end,
}
rex.bind(LEADER .. "f", "stop_port_forward")

-- ============================================================
--  CApi Module
--  A structured API wrapper for Growtopia scripting
-- ============================================================

local block_dialog = false
local CNews        = nil

-- Guard: prevent loading if already initialized
if pcall(function() return player.px end) then
    LogToConsole("`2[@AKM?] : CApi Already Loaded...\n")
    return
end

-- ============================================================
--  Utilities
-- ============================================================

local function bool_to_int(b)
    return b and 1 or 0
end

local function raw_name(name)
    return name:match("`%d(.+)``") or name
end

-- ============================================================
--  player — Local player actions
--  Usage: player:chat("hello")  player:tp(10, 5)
-- ============================================================

player = {}

function player:px()
    return math.floor(GetLocal().pos.x / 32)
end

function player:py()
    return math.floor(GetLocal().pos.y / 32)
end

function player:reconnect()
    SendVariantList({ [0] = "OnReconnect" }, -1)
end

function player:chat(text)
    SendPacket(2, "action|input\n|text|" .. text)
end

function player:wear(id)
    SendPacketRaw(false, { type = 10, value = id })
end

function player:warp(world, path)
    world = world:upper()

    local attempts = 0
    while GetWorld().name ~= world do
        attempts = attempts + 1
        RequestJoinWorld(world)
        Sleep(1000)
        if attempts >= 3 then
            LogToConsole("`4Error: Could not connect to world.")
            break
        end
    end

    if path then
        attempts = 0
        while GetTile(player:px(), player:py()).fg == 6 do
            attempts = attempts + 1
            SendPacket(3, "action|join_request\nname|" .. world .. "|" .. path .. "\ninvitedWorld|0")
            Sleep(1000)
            if attempts >= 3 then
                LogToConsole("`4Error: Path not found or connection failed.")
                break
            end
        end
    end
end

function player:tele(x, y)
    SendPacketRaw(false, { type = 0, value = 32, x = x * 32, y = y * 32 })
end

function player:tp(x, y)
    SendVariantList({
        [0] = "OnSetPos",
        [1] = { x = x * 32, y = y * 32 }
    }, GetLocal().netId)
end

function player:drop(id, amount)
    SendPacket(2, ("action|dialog_return\ndialog_name|drop_item\nitemID|%d|\ncount|%d\n"):format(id, amount))
end

function player:trash(id, amount)
    SendPacket(2, ("action|dialog_return\ndialog_name|trash_item\nitemID|%d|\ncount|%d\n"):format(id, amount))
end

-- ============================================================
--  players — Other players in the world
--  Usage: players:get_by_name("john"):kick()
-- ============================================================

players = {}

local function wrap_player(p)
    if not p then return nil end

    local name = raw_name(p.name)
    local ptab = { player = p }

    function ptab:pull()
        SendPacket(2, "action|input\n|text|/pull " .. name)
    end

    function ptab:kick()
        SendPacket(2, "action|input\n|text|/kick " .. name)
    end

    function ptab:ban()
        SendPacket(2, "action|input\n|text|/ban " .. name)
    end

    return ptab
end

function players:get_by_name(name)
    for _, p in pairs(GetPlayerList()) do
        if p.name:find(name) then return wrap_player(p) end
    end
    return false
end

function players:get_by_userid(id)
    for _, p in pairs(GetPlayerList()) do
        if p.userId == id then return wrap_player(p) end
    end
    return false
end

function players:get_by_netid(id)
    for _, p in pairs(GetPlayerList()) do
        if p.netId == id then return wrap_player(p) end
    end
    return false
end

-- ============================================================
--  inventory — Inventory management
--  Usage: inventory:check(242)  inventory:cbgl(true)
-- ============================================================

inventory = {}

function inventory:cbgl(should_block)
    block_dialog = should_block
    SendPacket(2, "action|dialog_return\ndialog_name|3898\nbuttonClicked|chc2_2_1\n")
end

function inventory:dtap(id)
    SendPacketRaw(false, { type = 10, value = id })
end

function inventory:check(id)
    for _, item in pairs(GetInventory()) do
        if item.id == id then return item.amount end
    end
    return 0
end

-- ============================================================
--  tile — Tile and block interactions
--  Usage: tile:punch(10, 5)  tile:place(10, 5, 242)
-- ============================================================

tile = {}

function tile:punch(x, y)
    SendPacketRaw(false, { type = 3, value = 18, x = x * 32, y = y * 32, punchx = x, punchy = y })
end

function tile:wrench(x, y)
    SendPacketRaw(false, { type = 3, value = 32, x = x * 32, y = y * 32, punchx = x, punchy = y })
end

function tile:place(x, y, id)
    SendPacketRaw(false, { type = 3, value = id, x = x * 32, y = y * 32, punchx = x, punchy = y })
end

function tile:vend(x, y)
    local extra = GetExtraTile(x, y) or {}
    local item  = extra.lastUpdate or 0
    local price = extra.owner or 0
    local vtab  = {}

    function vtab:buy(amount)
        SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nverify|1|\nbuycount|%d|\nexpectprice|%d|\nexpectitem|%d|\n"):format(x, y, amount, price, item))
    end

    function vtab:edit()
        local etab = {}

        function etab:pull()
            SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nbuttonClicked|pullstocks\n"):format(x, y))
        end

        function etab:add()
            SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nbuttonClicked|addstocks\n"):format(x, y))
        end

        function etab:set_price(new_price, per_item, per_lock)
            SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nsetprice|%d\nchk_peritem|%d\nchk_perlock|%d\n"):format(x, y, new_price, bool_to_int(per_item), bool_to_int(per_lock)))
        end

        return etab
    end

    return vtab
end

function tile:sucker(x, y)
    local stab = {}

    function stab:retrieve(amount)
        SendPacket(2, ("action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|%d|\ntiley|%d|\nitemtoremove|%d\n"):format(x, y, amount))
    end

    function stab:add(amount)
        SendPacket(2, ("action|dialog_return\ndialog_name|itemaddedtosucker\ntilex|%d|\ntiley|%d|\nitemtoadd|%d\n"):format(x, y, amount))
    end

    function stab:clear()
        SendPacket(2, ("action|dialog_return\ndialog_name|itemsucker_block\ntilex|%d|\ntiley|%d|\nbuttonClicked|clearitem\n\nchk_enablesucking|1\n"):format(x, y))
    end

    function stab:select(id)
        SendPacket(2, ("action|dialog_return\ndialog_name|itemsucker_block\ntilex|%d|\ntiley|%d|\nselectitem|%d\n"):format(x, y, id))
    end

    return stab
end

-- ============================================================
--  objects — Dropped world objects
--  Usage: objects:collect(242, 50)  objects:collect_in_radius(10, 5, 242)
-- ============================================================

objects = {}

function objects:collect(id, delay)
    delay = delay or 50
    for _, obj in pairs(GetObjectList()) do
        if obj.id == id and inventory:check(id) < 200 then
            SendPacketRaw(false, { type = 11, value = obj.oid, x = obj.pos.x, y = obj.pos.y })
            Sleep(delay)
        end
    end
end

function objects:collect_in_radius(x, y, id, radius)
    radius = radius or 10
    for _, obj in pairs(GetObjectList()) do
        local in_range = math.abs(obj.pos.x / 32 - x) <= radius
                      and math.abs(obj.pos.y / 32 - y) <= radius
        if in_range and (not id or obj.id == id) and obj.id ~= 0 then
            SendPacketRaw(false, { type = 11, value = obj.oid, x = obj.pos.x, y = obj.pos.y })
        end
    end
end

-- ============================================================
--  log — UI feedback
--  Usage: log:overlay("hello")  log:dialog("...")
-- ============================================================

log = {}

function log:overlay(text)
    SendVariantList({ [0] = "OnTextOverlay", [1] = text })
end

function log:dialog(struct)
    SendVariantList({ [0] = "OnDialogRequest", [1] = struct })
end

-- ============================================================
--  pathfind — A* with smart jump execution
--  Usage: pathfind(10, 5, 100)
-- ============================================================

function pathfind(goal_x, goal_y, delay)

    -- Min-heap priority queue — O(log n) push/pop
    local function make_heap()
        local h = {}

        local function swap(i, j) h[i], h[j] = h[j], h[i] end

        local function sift_up(i)
            while i > 1 do
                local p = math.floor(i / 2)
                if h[p].f > h[i].f then swap(p, i); i = p
                else break end
            end
        end

        local function sift_down(i)
            local n = #h
            while true do
                local s = i
                local l, r = 2 * i, 2 * i + 1
                if l <= n and h[l].f < h[s].f then s = l end
                if r <= n and h[r].f < h[s].f then s = r end
                if s == i then break end
                swap(i, s); i = s
            end
        end

        function h:push(node) table.insert(self, node); sift_up(#self) end

        function h:pop()
            local top = self[1]
            local n   = #self
            self[1]   = self[n]; self[n] = nil
            if #self > 0 then sift_down(1) end
            return top
        end

        function h:empty() return #self == 0 end
        return h
    end

    -- Helpers
    local WORLD_W = 100
    local function key(x, y) return y * WORLD_W + x end

    local function heuristic(ax, ay, bx, by)
        return math.abs(ax - bx) + math.abs(ay - by)
    end

    local function is_walkable(x, y)
        local t = GetTile(x, y)
        return t and (t.fg == 0 or t.fg % 2 == 1 or not t.collidable)
    end

    -- A* search
    local function astar(sx, sy, gx, gy)
        local heap    = make_heap()
        local came    = {}
        local g_score = {}
        local closed  = {}

        local sk = key(sx, sy)
        g_score[sk] = 0
        heap:push({ x = sx, y = sy, f = heuristic(sx, sy, gx, gy) })

        local dx = {  1, -1, 0,  0 }
        local dy = {  0,  0, 1, -1 }

        while not heap:empty() do
            local cur    = heap:pop()
            local cx, cy = cur.x, cur.y
            local ck     = key(cx, cy)

            if closed[ck] then goto continue end
            closed[ck] = true

            if cx == gx and cy == gy then
                local path = {}
                local node = ck
                while came[node] do
                    table.insert(path, { x = cx, y = cy })
                    local p = came[node]
                    cx, cy  = p.px, p.py
                    node    = key(cx, cy)
                end
                local lo, hi = 1, #path
                while lo < hi do
                    path[lo], path[hi] = path[hi], path[lo]
                    lo, hi = lo + 1, hi - 1
                end
                return path
            end

            local cg = g_score[ck]

            for i = 1, 4 do
                local nx, ny = cx + dx[i], cy + dy[i]
                local nk     = key(nx, ny)

                if not closed[nk] and is_walkable(nx, ny) then
                    local tg = cg + 1
                    if not g_score[nk] or tg < g_score[nk] then
                        came[nk]    = { px = cx, py = cy }
                        g_score[nk] = tg
                        heap:push({ x = nx, y = ny, f = tg + heuristic(nx, ny, gx, gy) })
                    end
                end
            end

            ::continue::
        end

        return nil
    end

    -- Smart jump execution
    local function execute(path)
        local n = #path
        local i = 1

        while i <= n do
            local cur       = path[i]
            local remaining = n - i

            local jump     = (remaining > 25 and 5)
                          or (remaining > 10 and 3)
                          or 1
            local target_i = math.min(i + jump, n)
            local target   = path[target_i]

            local ddx      = target.x - cur.x
            local ddy      = target.y - cur.y
            local steps    = math.max(math.abs(ddx), math.abs(ddy))
            local can_skip = true

            for s = 1, steps do
                local cx = cur.x + math.floor(ddx * s / steps)
                local cy = cur.y + math.floor(ddy * s / steps)
                if not is_walkable(cx, cy) then
                    can_skip = false
                    break
                end
            end

            if can_skip then
                FindPath(target.x, target.y)
                Sleep(math.floor(delay * jump / 5))
                i = target_i + 1
            else
                FindPath(cur.x, cur.y)
                Sleep(delay)
                i = i + 1
            end
        end

        local last = path[n]
        if last then FindPath(last.x, last.y) end
    end

    -- Run
    local sx   = math.floor(GetLocal().pos.x / 32)
    local sy   = math.floor(GetLocal().pos.y / 32)
    local path = astar(sx, sy, goal_x, goal_y)

    if path then
        execute(path)
    else
        LogToConsole("No valid path found.")
    end
end

-- ============================================================
--  Hooks
-- ============================================================

AddHook("OnVarlist", "ca_dialogblock", function(var)
    if var[0] == "OnDialogRequest" and block_dialog then
        block_dialog = false
        return true
    end
end)

AddHook("OnTextPacket", "ca_news", function(type, pkt)
    if type == 2 then
        local cmd = pkt:match("text|/(.-)\n")
        if cmd and cmd:upper() == "NEWS" and CNews then
            SendVariantList({ [0] = "OnDialogRequest", [1] = CNews })
        end
    end
end)

LogToConsole("`2[@AKM?] : CApi Block Dialog & News Hook Loaded...\n")

-- ============================================================
--  Announcement — fetch & cache from remote
-- ============================================================

local function announcement()
    local filepath = "/storage/emulated/0/Documents/CApi.txt"

    while true do
        local file = io.open(filepath, "r")

        if file then
            local cached = file:read("*a")
            file:close()

            local res   = MakeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/announcement.txt", "GET")
            local fresh = res and res.content or ""

            if tostring(cached) ~= tostring(fresh) then
                file = io.open(filepath, "w")
                if file then file:write(fresh); file:close() end
                CNews = load(fresh)()  -- ⚠️ Executes remote Lua — ensure the source is trusted
                SendVariantList({ [0] = "OnDialogRequest", [1] = CNews })
            else
                CNews = fresh
                log:overlay("`b[`c/news`b] `cType /news to open CApi News")
            end

            LogToConsole("`2[@AKM?] : CApi Announcement Rendered...\n")
            break
        else
            file = io.open(filepath, "w")
            if file then file:write("𝖖𝖐𝖒 𝖜𝖆𝖘 𝖍𝖊𝖗𝖊"); file:close() end
            LogToConsole("`2[@AKM?] : CApi Creating Cache File...\n")
            Sleep(500)
        end
    end
end

announcement()

LogToConsole("`2[@AKM?] : CApi Successfully Loaded...\n")

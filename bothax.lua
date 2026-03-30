local block_dialog = false
local CNews = nil

local function booltoint(bool)
    return bool and 1 or 0
end

if pcall(function() return player().px end) then
    LogToConsole("`2[@AKM?] : CApi Already Loaded...\n")
    return
end

function player()
    local tab = {}

    function tab:px()
        return math.floor(GetLocal().pos.x / 32)
    end

    function tab:py()
        return math.floor(GetLocal().pos.y / 32)
    end

    function tab:reconnect()
        SendVariantList({[0] = "OnReconnect"}, -1)
    end

    function tab:chat(txt)
        SendPacket(2, "action|input\n|text|" .. txt)
    end

    function tab:wear(id)
        local pkt = { type = 10, value = id }
        SendPacketRaw(false, pkt)
    end

    function tab:warp(world, path)
        world = world:upper()
        local looped = 0
        while GetWorld().name ~= world do
            looped = looped + 1
            RequestJoinWorld(world)
            Sleep(1000)
            if looped >= 3 then
                LogToConsole("`4Error Connection?")
                break
            end
        end

        if path then
            looped = 0
            while GetTile(tab:px(), tab:py()).fg == 6 do
                looped = looped + 1
                SendPacket(3, "action|join_request\nname|" .. world .. "|" .. path .. "\ninvitedWorld|0")
                Sleep(1000)
                if looped >= 3 then
                    LogToConsole("`4Not Found Path / Error Connection?")
                    break
                end
            end
        end
    end

    function tab:tele(x, y)
        local pkt = { type = 0, value = 32, x = x * 32, y = y * 32 }
        SendPacketRaw(false, pkt)
    end

    function tab:tp(x, y)
        SendVariantList({
            [0] = "OnSetPos",
            [1] = { x = x * 32, y = y * 32 }
        }, GetLocal().netId)
    end

    function tab:drop(id, amount)
        SendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|" .. id .. "|\ncount|" .. amount .. "\n")
    end

    function tab:trash(id, amount)
        SendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|" .. id .. "|\ncount|" .. amount .. "\n")
    end

    function tab:pathfind(goalX,goalY)
      local function heuristic(a, b)
          return math.abs(a.x - b.x) + math.abs(a.y - b.y)
      end
      
      local function isWalkable(x, y)
          local tile = GetTile(x, y)
          return tile and tile.fg == 0 and tile.bg == 0 and not tile.collidable
      end
      
      local function posKey(x, y)
          return x .. "," .. y
      end
      
      function pathfindAStar(startX, startY, goalX, goalY)
          local openSet = {}
          local cameFrom = {}
          local gScore = {}
          local fScore = {}
      
          local startKey = posKey(startX, startY)
          gScore[startKey] = 0
          fScore[startKey] = heuristic({x = startX, y = startY}, {x = goalX, y = goalY})
      
          table.insert(openSet, {x = startX, y = startY, f = fScore[startKey]})
      
          while #openSet > 0 do
              table.sort(openSet, function(a, b) return a.f < b.f end)
              local current = table.remove(openSet, 1)
              local cx, cy = current.x, current.y
      
              if cx == goalX and cy == goalY then
                  local path = {}
                  local currKey = posKey(cx, cy)
                  while cameFrom[currKey] do
                      table.insert(path, 1, cameFrom[currKey].from)
                      currKey = cameFrom[currKey].prev
                  end
                  return path
              end
      
              local neighbors = {
                  {x = cx + 1, y = cy},
                  {x = cx - 1, y = cy},
                  {x = cx, y = cy + 1},
                  {x = cx, y = cy - 1}
              }
      
              for _, neighbor in ipairs(neighbors) do
                  local nx, ny = neighbor.x, neighbor.y
                  local nKey = posKey(nx, ny)
      
                  if isWalkable(nx, ny) then
                      local tentativeG = gScore[posKey(cx, cy)] + 1
                      if not gScore[nKey] or tentativeG < gScore[nKey] then
                          cameFrom[nKey] = {from = {x = nx, y = ny}, prev = posKey(cx, cy)}
                          gScore[nKey] = tentativeG
                          fScore[nKey] = tentativeG + heuristic({x = nx, y = ny}, {x = goalX, y = goalY})
      
                          local exists = false
                          for _, node in ipairs(openSet) do
                              if node.x == nx and node.y == ny then
                                  exists = true
                                  break
                              end
                          end
                          if not exists then
                              table.insert(openSet, {x = nx, y = ny, f = fScore[nKey]})
                          end
                      end
                  end
              end
          end
      
          return nil
      end
      
      -- Example: walking from current position to (goalX, goalY)
      local startX = math.floor(getLocal().pos.x / 32)
      local startY = math.floor(getLocal().pos.y / 32)
      
      local path = pathfindAStar(startX, startY, goalX, goalY)
      if path then
          for i, step in ipairs(path) do
              findPath(step.x, step.y)
              sleep(100)
          end
      else
          doLog("No valid path found.")
      end
    end

    return tab
end

function players()
    local tab = {}

    local function createPlayerTab(p)
        if not p then return nil end
        local rawname = p.name:match("`%d(.+)``") or p.name

        local ptab = { player = p }

        function ptab:pull()
            SendPacket(2, "action|input\n|text|/pull " .. rawname)
        end

        function ptab:kick()
            SendPacket(2, "action|input\n|text|/kick " .. rawname)
        end

        function ptab:ban()
            SendPacket(2, "action|input\n|text|/ban " .. rawname)
        end

        return ptab
    end

    function tab:getbyname(name)
        for _, v in pairs(GetPlayerList()) do
            if v.name:find(name) then
                return createPlayerTab(v)
            end
        end
        return nil
    end

    function tab:getbyuserid(id)
        for _, v in pairs(GetPlayerList()) do
            if v.userId == id then
                return createPlayerTab(v)
            end
        end
        return nil
    end

    function tab:getbynetid(id)
        for _, v in pairs(GetPlayerList()) do
            if v.netId == id then
                return createPlayerTab(v)
            end
        end
        return nil
    end

    return tab
end

function inventory()
    local tab = {}

    function tab:cbgl(bdialog)
        block_dialog = bdialog
        SendPacket(2, "action|dialog_return\ndialog_name|3898\nbuttonClicked|chc2_2_1\n")
    end

    function tab:dtap(id)
        local pkt = { type = 10, value = id }
        SendPacketRaw(false, pkt)
    end

    function tab:check(id)
        for _, v in pairs(GetInventory()) do
            if v.id == id then
                return v.amount
            end
        end
        return 0
    end

    return tab
end

local function tile()
    local tab = {}

    function tab:punch(x, y)
        local pkt = { type = 3, value = 18, x = x*32, y = y*32, punchx = x, punchy = y }
        SendPacketRaw(false, pkt)
    end

    function tab:wrench(x, y)
        local pkt = { type = 3, value = 32, x = x*32, y = y*32, punchx = x, punchy = y }
        SendPacketRaw(false, pkt)
    end

    function tab:place(x, y, id)
        local pkt = { type = 3, value = id, x = x*32, y = y*32, punchx = x, punchy = y }
        SendPacketRaw(false, pkt)
    end

    function tab:vend(x, y)
        local extra = GetExtraTile(x, y) or {}
        local vid = extra.lastUpdate or 0
        local vprice = extra.owner or 0

        local vtab = {}

        function vtab:buy(amount)
            SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nverify|1|\nbuycount|%d|\nexpectprice|%d|\nexpectitem|%d|\n"):format(x, y, amount, vprice, vid))
        end

        function vtab:edit()
            local etab = {}
            function etab:pull() SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nbuttonClicked|pullstocks\n"):format(x,y)) end
            function etab:add()  SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nbuttonClicked|addstocks\n"):format(x,y)) end
            function etab:price(price, peritem, perlock)
                SendPacket(2, ("action|dialog_return\ndialog_name|vending\ntilex|%d|\ntiley|%d|\nsetprice|%d\nchk_peritem|%d\nchk_perlock|%d\n"):format(x,y,price,booltoint(peritem),booltoint(perlock)))
            end
            return etab
        end

        return vtab
    end

    function tab:sucker(x, y)
        local stab = {}
        function stab:retrive(amount)
            SendPacket(2, ("action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|%d|\ntiley|%d|\nitemtoremove|%d\n"):format(x,y,amount))
        end
        function stab:add(amount)
            SendPacket(2, ("action|dialog_return\ndialog_name|itemaddedtosucker\ntilex|%d|\ntiley|%d|\nitemtoadd|%d\n"):format(x,y,amount))
        end
        function stab:clear()
            SendPacket(2, ("action|dialog_return\ndialog_name|itemsucker_block\ntilex|%d|\ntiley|%d|\nbuttonClicked|clearitem\n\nchk_enablesucking|1\n"):format(x,y))
        end
        function stab:select(id)
            SendPacket(2, ("action|dialog_return\ndialog_name|itemsucker_block\ntilex|%d|\ntiley|%d|\nselectitem|%d\n"):format(x,y,id))
        end
        return stab
    end

    return tab
end

function objects()
    local tab = {}

    function tab:collect(id, delay)
        delay = delay or 50
        for _, v in pairs(GetObjectList()) do
            if v.id == id and inventory():check(id) < 200 then
                local pkt = { type = 11, value = v.oid, x = v.pos.x, y = v.pos.y }
                SendPacketRaw(false, pkt)
                Sleep(delay)
            end
        end
    end

    function tab:cpos(x, y, id, rad)
        rad = rad or 10
        local list = {}
        for _, v in pairs(GetObjectList()) do
            if (not id or v.id == id) and v.id ~= 0 then
                local dx = math.abs(v.pos.x / 32 - x)
                local dy = math.abs(v.pos.y / 32 - y)
                if dx <= rad and dy <= rad then
                    table.insert(list, v)
                end
            end
        end

        for _, obj in ipairs(list) do
            local pkt = { type = 11, value = obj.oid, x = obj.pos.x, y = obj.pos.y }
            SendPacketRaw(false, pkt)
        end
    end

    return tab
end

function log()
    local tab = {}

    function tab:overlay(txt)
        SendVariantList({ [0] = "OnTextOverlay", [1] = txt })
    end

    function tab:dialog(struct)
        SendVariantList({ [0] = "OnDialogRequest", [1] = struct })
    end

    return tab
end

LogToConsole("\n`2[@AKM?] : CApi Module Loaded...\n")

local function diahook(var)
    if var[0] == "OnDialogRequest" and block_dialog then
        block_dialog = false
        return true
    end
end

AddHook("OnVarlist", "ca_dialogblock", diahook)

local function txthook(type, pkt)
    if type == 2 then
        local cmd = pkt:match("text|/(.-)\n")
        if cmd and cmd:upper() == "NEWS" and CNews then
            SendVariantList({ [0] = "OnDialogRequest", [1] = CNews })
        end
    end
end

AddHook("OnTextPacket", "ca_news", txthook)

LogToConsole("\n`2[@AKM?] : CApi Block Dialog & News Hook Loaded...\n")

local function announcement()
    local filepath = "/storage/emulated/0/Documents/CApi.txt"

    while true do
        local file = io.open(filepath, "r")
        if file then
            local clientmes = file:read("*a")
            file:close()

            local response = MakeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/announcement.txt", "GET")
            local mes = response and response.content or ""

            if tostring(clientmes) ~= tostring(mes) then
                file = io.open(filepath, "w")
                if file then
                    file:write(mes)
                    file:close()
                end
                CNews = load(mes)()
                SendVariantList({ [0] = "OnDialogRequest", [1] = CNews })
            else
                CNews = mes
                log():overlay("`b[`c/news`b] `cTo Open CApi News")
            end

            LogToConsole("\n`2[@AKM?] : CApi Announcement Rendered...\n")
            break
        else
            file = io.open(filepath, "w")
            if file then
                file:write("𝖖𝖐𝖒 𝖜𝖆𝖘 𝖍𝖊𝖗𝖊")
                file:close()
            end
            LogToConsole("\n`2[@AKM?] : CApi Making A New File...\n")
            Sleep(500)
        end
    end
end

announcement()

LogToConsole("\n`2[@AKM?] : CApi Successfully Loaded...\n")

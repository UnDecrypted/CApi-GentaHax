capi = {}

-- Usefull

local block_dialog = false

capi.px = function()
  return math.floor(getLocal().pos.x/32)
end

capi.py = function()
  return math.floor(getLocal().pos.y/32)
end

capi.recon = function()
  sendVariant({[0] = "OnReconnect"},-1)
end

capi.conbgl = function(bdialog)
  if not bdialog then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.conbgl(Block Dialog : Bool)")
    return
  end
  if bdialog == true then
    block_dialog = true
  end
  sendPacket(2, "action|dialog_return\ndialog_name|3898\nbuttonClicked|chc2_2_1\n")
end

capi.wear = function(cid)
  if not cid then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.wear(Clothes ID : Int)")
    return
  end
  sendPacketRaw(false,
  {
  type = 10,
  value = cid, 
  })
end

capi.change = function(id)
  if not id then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.change(Lock ID : Int)")
    return
  end
  pkt = {}
  pkt.type = 10;
  pkt.value = id;
  sendPacketRaw (false, pkt);
end

capi.collect = function(id)
  if not id then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.collect(Item ID : Int)")
    return
  end
  for i, v in pairs(getWorldObject()) do
    if v.id == id then
      local pkt = {}
      pkt.type = 11
      pkt.value = v.oid
      pkt.x = v.pos.x
      pkt.y = v.pos.y
      sendPacketRaw(false, pkt)
    end
  end
end

capi.cinv = function(id)
  if not id then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.cinv(Item ID : Int)")
    return
  end
  for i, v in pairs(getInventory()) do
    if v.id == id then
      return v.amount
    end
  end
end

capi.warp = function(world,path)
  if not world or not path then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.warp(World : Str,Path : Str)")
    return
  end
  local looped = 0
  while getWorld().name ~= world:upper() do
    looped = looped + 1
    sendPacket(3,"action|join_request\nname|"..world.."|"..path.."\ninvitedWorld|0")
    sleep(1000)
    if looped == 3 then
      logToConsole("Error Connection?")
      break
    end
  end
  looped = 0
  if checkTile(math.floor(getLocal().pos.x/32),math.floor(getLocal().pos.y/32)).fg then
    while checkTile(math.floor(getLocal().pos.x/32),math.floor(getLocal().pos.y/32)).fg == 6 do
      looped = looped + 1
      sendPacket(3,"action|join_request\nname|"..world.."|"..path.."\ninvitedWorld|0")
      sleep(1000)
      if looped == 3 then
        logToConsole("Not Found Path / Error Connection?")
        break
      end
    end
  end
end

capi.vistp = function(x,y)
  if not x or not y then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.vistp(Tile X : Int,Tile Y : Int)")
    return
  end
  pkt = {}
  pkt.type = 0
  pkt.value = 32
  pkt.x = x*32
  pkt.y = y*32
  sendPacketRaw(false, pkt)
end

capi.punch = function(x,y)
  if not x or not y then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.punch(Tile X : Int,Tile Y : Int)")
    return
  end
  pkt = {}
  pkt.x = getLocal().pos.x
  pkt.y = getLocal().pos.y
  pkt.punchx = x
  pkt.punchy = y
  pkt.type = 3;
  pkt.value = 18;
  sendPacketRaw(false, pkt);
end

capi.wrench = function(x,y)
  if not x or not y then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.wrench(Tile X : Int,Tile Y : Int)")
    return
  end
  pkt = {}
  pkt.x = getLocal().pos.x
  pkt.y = getLocal().pos.y
  pkt.punchx = x
  pkt.punchy = y
  pkt.type = 3;
  pkt.value = 32;
  sendPacketRaw(false, pkt);
end

capi.place = function(x,y,id)
  if not x or not y or not id then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.place(Tile X : Int,Tile Y : Int,Block ID : Int)")
    return
  end
  pkt = {}
  pkt.x = getLocal().pos.x
  pkt.y = getLocal().pos.y
  pkt.punchx = x
  pkt.punchy = y
  pkt.type = 3;
  pkt.value = id;
  sendPacketRaw(false, pkt);
end

capi.drop = function(id,amount,delay)
  if not id or not amount or not delay then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.drop(Item ID : Int,Amount : Int,Delay : Int)")
    return
  end
  sendPacket(2,"action|drop\n|itemID|"..id)
  sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount)
  sleep(delay)
end

capi.cdpos = function(x,y,rad)
  if not x or not y or not rad then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.cdpos(Tile X : Int,Tile Y : Int,Radius : Int)")
    return
  end
  local TotalAmount = 0
  for i, v in pairs(getWorldObject()) do
    local jx = math.abs(v.pos.x/32-x)
    local jx = math.abs(v.pos.y/32-y)
    if jx <= rad and jy <= rad then
      if v.id == id then
        TotalAmount = TotalAmount + v.amount
      end
    end
  end
  return TotalAmount
end

capi.cpos = function(x,y,id,rad)
  if not x or not y or not id or not rad then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.cpos(Tile X : Int,Tile Y : Int,Item ID : Int,Radius : Int)")
    return
  end
  local CItem = {}
  for i, v in pairs(getWorldObject()) do
    if id ~= nil then
      if v.id ~= 0 and v.id == id then
        local xdist = math.abs(v.pos.x/32-x)
        local ydist = math.abs(v.pos.y/32-y)
        if xdist <= rad and ydist <= rad then
          table.insert(CItem,v)
        end
      end
    else
      if v.id ~= 0 then
        local xdist = math.abs(v.pos.x/32-x)
        local ydist = math.abs(v.pos.y/32-y)
        if xdist <= rad and ydist <= rad then
          table.insert(CItem,v)
        end
      end
    end
  end
  if #CItem > 0 then
    for i,v in pairs(CItem) do
      local pkt = {}
      pkt.type = 11
      pkt.value = v.oid
      pkt.x = v.pos.x
      pkt.y = v.pos.y
      sendPacketRaw(false, pkt)
    end
  end
end

capi.findpath = function(x,y,pdelay,jscan)
  if not x or not y or not pdelay or not jscan then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.findpath(Tile X : Int,Tile Y : Int,Delay : Int,Scan Tile Radius : Int)")
    return
  end
  local perror = 0
  local timex = 0
  local timey = 0
  local MoveTo = function(x,y)
    local success = findPath(math.floor(getLocal().pos.x/32)+x,math.floor(getLocal().pos.y/32)+y)
    if success == true then
      sleep(pdelay*math.abs(x))
      sleep(pdelay*math.abs(y))
      return success
    end
  end
  while true do
    if perror == 3 then
      capi.sover("Path Error?")
      break
    end
    local px = math.floor(getLocal().pos.x/32)
    local py = math.floor(getLocal().pos.y/32)
    timex = math.abs(px-x)
    timey = math.abs(py-y)
    if px < x then
      if math.abs(px-x) > 10 then
        if MoveTo(10,0) then
        else
          local spath = false
          for i=jscan, 1, -1 do
            if MoveTo(i,0) and spath == false then
              spath = true
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      else
        if MoveTo(1,0) then
        else
          local spath = false
          for i=1, jscan, 1 do
            if MoveTo(i,0) and spath == false then
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      end
    end
    if px > x then
      if math.abs(px-x) > 10 then
        if MoveTo(-10,0) then
        else
          local spath = false
          for i=jscan, 1, -1 do
            if MoveTo(-i,0) and spath == false then
              spath = true
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      else
        if MoveTo(-1,0) then
        else
          local spath = false
          for i=1, jscan, 1 do
            if MoveTo(-i,0) and spath == false then
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      end
    end
    if py < y then
      if math.abs(py-y) > 10 then
        if MoveTo(0,10) then
        else
          local spath = false
          for i=jscan, 1, -1 do
            if MoveTo(0,i) and spath == false then
              spath = true
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      else
        if MoveTo(0,1) then
        else
          local spath = false
          for i=1, jscan, 1 do
            if MoveTo(0,i) and spath == false then
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      end
    end
    if py > y then
      if math.abs(py-y) > 10 then
        if MoveTo(0,-10) then
        else
          local spath = false
          for i=jscan, 1, -1 do
            if MoveTo(0,-i) and spath == false then
              spath = true
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      else
        if MoveTo(0,-1) then
        else
          local spath = false
          for i=1, jscan, 1 do
            if MoveTo(0,-i) and spath == false then
              return
            end
          end
          if spath == false then
            perror = perror + 1
          end
        end
      end
    end
    if px == x and py == y then
      break
    end
  end
end

-- Useless

capi.sover = function(txt)
  if not txt then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.sover(Text : Str)")
    return
  end
  var = {}
  var[0] = "OnTextOverlay"
  var[1] = txt
  sendVariant(var)
end

capi.sdial = function(struct)
  if not struct then
    capi.sover("[CApi Error]\nSome Argument Missing\nHere : capi.sdial(Dialog Struct : Str)")
    return
  end
  var = {}
  var[0] = "OnDialogRequest"
  var[1] = struct
  sendVariant(var)
end

function pktfunc(type, pkt)
  if pkt:find("action|input\n|text|") then
    if pkt:find("/api") then
      local dump = "add_label_with_icon|big|`9[CApi] Api List``|left|1796"
      for i,v in pairs(capi) do
        dump = dump.."add_smalltext|"..i.."()|\n"
      end
      capi.sdial(dump)
    end
  end
end

function hook(var)
  if var[0] == "OnDialogRequest" then
    if block_dialog == true then
      block_dialog = false
      return true
    end
  end
end

AddHook("OnVarlist", "var", hook)

AddHook("OnTextPacket", "jdjjx", pktfunc)

logToConsole("\n`4[@AKM?] : CApi Is Loaded\nList Api? Just Type /api")

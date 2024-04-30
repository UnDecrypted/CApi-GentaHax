capi = {}

-- Usefull

capi.px = function()
  return math.floor(getLocal().pos.x/32)
end

capi.py = function()
  return math.floor(getLocal().pos.y/32)
end

capi.cinv = function(id)
  for i, v in pairs(getInventory()) do
    if v.id == id then
      return v.amount
    end
  end
end

capi.warp = function(world,path)
  while getWorld().name ~= world:upper() do
    doLog("not same")
    sendPacket(3,"action|join_request\nname|"..world.."|"..path.."\ninvitedWorld|0")
    sleep(1000)
  end
  while checkTile(math.floor(getLocal().pos.x/32),math.floor(getLocal().pos.y/32)).fg == 6 do
    doLog("in white door")
    sendPacket(3,"action|join_request\nname|"..world.."|"..path.."\ninvitedWorld|0")
    sleep(1000)
  end
  doLog("done")
end

capi.punch = function(x,y)
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
  sendPacket(2,"action|drop\n|itemID|"..id)
  sleep(delay)
 
 sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount)
  sleep(delay)
end

capi.cdpos = function(x,y,rad)
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

-- Useless

capi.sover = function(txt)
  var = {}
  var[0] = "OnTextOverlay"
  var[1] = txt
  sendVariant(var)
end

capi.sdial = function(struct)
  var = {}
  var[0] = "OnDialogRequest"
  var[1] = struct
  sendVariant(var)
end

function hook(type, pkt)
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

AddHook("OnTextPacket", "jdjjx", hook)

logToConsole("`4[@AKM?] : CApi Is Loaded\nList Api? Just Type /api")

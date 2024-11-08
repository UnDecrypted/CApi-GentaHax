block_dialog = false

capi = {}
capi.ver = "2.0"
capi.info = {
  ["px"] = {
    ["cmd"] = "px()",
    ["usage"] = "to get player x",
    ["run"] = [[function()
      return math.floor(getLocal().pos.x/32)
    end]],
    ["error"] = ""
  },
  ["py"] = {
    ["cmd"] = "py()",
    ["usage"] = "to get player y",
    ["run"] = [[function()
      return math.floor(getLocal().pos.y/32)
    end]],
    ["error"] = ""
  },
  ["recon"] = {
    ["cmd"] = "recon()",
    ["usage"] = "to reconnect from server",
    ["run"] = [[function()
      sendVariant({[0] = "OnReconnect"},-1)
    end]],
    ["error"] = ""
  },
  ["conbgl"] = {
    ["cmd"] = "conbgl(Block Dialog : Bool)",
    ["usage"] = "to convery diamond lock to bgl",
    ["run"] = [[function(bdialog)
      if not bdialog then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.conbgl(Block Dialog : Bool)")
        sleep(1000)
        return
      end
      block_dialog = bdialog
      sendPacket(2, "action|dialog_return\ndialog_name|3898\nbuttonClicked|chc2_2_1\n")
    end]],
    ["error"] = ""
  },
  ["wear"] = {
    ["cmd"] = "wear(Clothes ID : Int)",
    ["usage"] = "to set player costume",
    ["run"] = [[function(cid)
      if not cid then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.wear(Clothes ID : Int)")
        sleep(1000)
        return
      end
      sendPacketRaw(false,
      {
      type = 10,
      value = cid, 
      })
    end]],
    ["error"] = ""
  },
  ["change"] = {
    ["cmd"] = "change(Block ID : Int)",
    ["usage"] = "to convert wl to dl or dl to wl",
    ["run"] = [[function(id)
      if not id then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.change(Lock ID : Int)")
        sleep(1000)
        return
      end
      pkt = {}
      pkt.type = 10;
      pkt.value = id;
      sendPacketRaw (false, pkt);
    end]],
    ["error"] = ""
  },
  ["collect"] = {
    ["cmd"] = "collect(Item ID : Int,Delay : Int)",
    ["usage"] = "to brute collect all specific item",
    ["run"] = [[function(id,delay)
      if not id or not delay then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.collect(Item ID : Int,Delay : Int)")
        sleep(1000)
        return
      end
      for i, v in pairs(getWorldObject()) do
        if v.id == id then
          if cinv(v.id) < 200 then
            local pkt = {}
            pkt.type = 11
            pkt.value = v.oid
            pkt.x = v.pos.x
            pkt.y = v.pos.y
            sendPacketRaw(false, pkt)
            sleep(delay)
          end
        end
      end
    end]],
    ["error"] = ""
  },
  ["cinv"] = {
    ["cmd"] = "cinv(Item ID : Int)",
    ["usage"] = "to check inventory of player",
    ["run"] = [[function(id)
      if not id then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.cinv(Item ID : Int)")
        sleep(1000)
        return
      end
      for i, v in pairs(getInventory()) do
        if v.id == id then
          return v.amount
        end
      end
      return 0
    end]],
    ["error"] = ""
  },
  ["warp"] = {
    ["cmd"] = "warp(World : Str,Path : Str)",
    ["usage"] = "to join world",
    ["run"] = [[function(world,path)
      if not world or not path then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.warp(World : Str,Path : Str)")
        sleep(1000)
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
    end]],
    ["error"] = ""
  },
  ["vistp"] = {
    ["cmd"] = "vistp(X : Int,Y : Int)",
    ["usage"] = "to teleport player but only on server not client",
    ["run"] = [[function(x,y)
      if not x or not y then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.vistp(Tile X : Int,Tile Y : Int)")
        sleep(1000)
        return
      end
      pkt = {}
      pkt.type = 0
      pkt.value = 32
      pkt.x = x*32
      pkt.y = y*32
      sendPacketRaw(false, pkt)
    end]],
    ["error"] = ""
  },
  ["punch"] = {
    ["cmd"] = "punch(X : Int,Y : Int)",
    ["usage"] = "to punch specific tile",
    ["run"] = [[function(x,y)
      if not x or not y then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.punch(Tile X : Int,Tile Y : Int)")
        sleep(1000)
        return
      end
      pkt = {}
      pkt.x = x*32
      pkt.y = y*32
      pkt.punchx = x
      pkt.punchy = y
      pkt.type = 3;
      pkt.value = 18;
      sendPacketRaw(false, pkt);
    end]],
    ["error"] = ""
  },
  ["wrench"] = {
    ["cmd"] = "wrench(X : Int,Y : Int)",
    ["usage"] = "to wrench specific tile",
    ["run"] = [[function(x,y)
      if not x or not y then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.wrench(Tile X : Int,Tile Y : Int)")
        sleep(1000)
        return
      end
      pkt = {}
      pkt.x = x*32
      pkt.y = y*32
      pkt.punchx = x
      pkt.punchy = y
      pkt.type = 3;
      pkt.value = 32;
      sendPacketRaw(false, pkt);
    end]],
    ["error"] = ""
  },
  ["place"] = {
    ["cmd"] = "place(X : Int,Y : Int,Block ID : Int)",
    ["usage"] = "to place block on specific tile",
    ["run"] = [[function(x,y,id)
      if not x or not y or not id then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.place(Tile X : Int,Tile Y : Int,Block ID : Int)")
        sleep(1000)
        return
      end
      pkt = {}
      pkt.x = x*32
      pkt.y = y*32
      pkt.punchx = x
      pkt.punchy = y
      pkt.type = 3;
      pkt.value = id;
      sendPacketRaw(false, pkt);
    end]],
    ["error"] = ""
  },
  ["cdpos"] = {
    ["cmd"] = "cdpos(X : Int,Y : Int,Radius : Num)",
    ["usage"] = "to check floating item on specific tile",
    ["run"] = [[function(x,y,rad)
      if not x or not y or not rad then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.cdpos(Tile X : Int,Tile Y : Int,Radius : Int)")
        sleep(1000)
        return
      end
      local TotalAmount = 0
      for i, v in pairs(getWorldObject()) do
        local jx = math.abs(v.pos.x/32-x)
        local jy = math.abs(v.pos.y/32-y)
        if jx <= rad and jy <= rad/1.4 then
           TotalAmount = TotalAmount + v.amount
        end
      end
      return TotalAmount
    end]],
    ["error"] = ""
  },
  ["drop"] = {
    ["cmd"] = "drop(Item ID : Int,Amount : Int,Delay : Int,Block Dialog : Bool)",
    ["usage"] = "to drop specific item",
    ["run"] = [[function(id,amount,delay,bdialog)
      if not id or not amount or not delay or not bdialog then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.drop(Item ID : Int,Amount : Int,Delay : Int,Block Dialog : Bool)")
        sleep(1000)
        return
      end
      block_dialog = bdialog
      sleep(delay)
      sendPacket(2,"action|drop\n|itemID|"..id)
      sleep(delay)
      sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount.."\n")
    end]],
    ["error"] = ""
  },
  ["trash"] = {
    ["cmd"] = "trash(Item ID : Int,Amount : Int,Delay : Int,Block Dialog : Bool)",
    ["usage"] = "to trash specific item",
    ["run"] = [[function(id,amount,delay,bdialog)
      if not id or not amount or not delay or not bdialog then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.trash(Item ID : Int,Amount : Int,Delay : Int,Block Dialog : Bool)")
        sleep(1000)
        return
      end
      block_dialog = bdialog
      sleep(delay)
      sendPacket(2, "action|trash\n|itemID|"..id)
      sleep(delay)
      sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..id.."|\ncount|"..amount.."\n")
    end]],
    ["error"] = ""
  },
  ["cpos"] = {
    ["cmd"] = "cpos(X : Int,Y : Int,Item ID : Int,Radius : Num)",
    ["usage"] = "to collect item at specific tile, item id = nil to collect all",
    ["run"] = [[function(x,y,id,rad)
      if not x or not y or not rad then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.cpos(Tile X : Int,Tile Y : Int,Item ID : Int,Radius : Int)")
        sleep(1000)
        return
      end
      local CItem = {}
      for i, v in pairs(getWorldObject()) do
        if id ~= nil then
          if v.id ~= 0 and v.id == id then
            local xdist = math.abs(v.pos.x/32-x)
            local ydist = math.abs(v.pos.y/32-y)
            if xdist <= rad and ydist <= rad/1.4 then
              table.insert(CItem,v)
            end
          end
        else
          if v.id ~= 0 then
            local xdist = math.abs(v.pos.x/32-x)
            local ydist = math.abs(v.pos.y/32-y)
            if xdist <= rad and ydist <= rad/1.3 then
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
    end]],
    ["error"] = ""
  },
  ["findpath"] = {
    ["cmd"] = "findpath()",
    ["usage"] = "still error",
    ["run"] = [[function()
    
    end]],
    ["error"] = ""
  },
  ["sover"] = {
    ["cmd"] = "sover(Text : String)",
    ["usage"] = "send overlay",
    ["run"] = [[function(txt)
      if not txt then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.sover(Text : Str)")
        sleep(1000)
        return
      end
      var = {}
      var[0] = "OnTextOverlay"
      var[1] = txt
      sendVariant(var)
    end]],
    ["error"] = ""
  },
  ["sdial"] = {
    ["cmd"] = "sdial(Struct : String)",
    ["usage"] = "still error",
    ["run"] = [[function(struct)
      if not struct then
        sover("[CApi Error]\nSome Argument Missing\nHere : capi.sdial(Dialog Struct : Str)")
        sleep(1000)
        return
      end
      var = {}
      var[0] = "OnDialogRequest"
      var[1] = struct
      sendVariant(var)
    end]],
    ["error"] = ""
  }
}

for i,v in pairs(capi.info) do
  load(i.."="..v.run)()
end

function pktfunc(type, pkt)
  if pkt:find("action|input\n|text|") then
    if pkt:find("/api") then
      local dump = "add_label_with_icon|big|`9[CApi : "..capi.ver.."] Api List``|left|1796"
      for i,v in pairs(capi.info) do
        dump = dump.."add_smalltext|"..i.." : "..v.cmd.."|\n"
      end
      sdial(dump)
    end
    if pkt:find("/usage") then
      local dump = "add_label_with_icon|big|`9[CApi : "..capi.ver.."] Api Utility``|left|1796"
      for i,v in pairs(capi.info) do
        dump = dump.."add_smalltext|"..i.." : "..v.usage.."|\n"
      end
      sdial(dump)
    end
  end
end

function varfunc(var)
  if var[0] == "OnDialogRequest" then
    if block_dialog == true then
      block_dialog = false
      return true
    end
  end
end

function announcement()
  while true do
    local file = io.open("/storage/emulated/0/Documents/CApi.txt","r")
    if file then
      local clientmes = file:read("*a")
      file:close()
      
      local mes = makeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/announcement.txt", "GET").content
      
      if tostring(clientmes) ~= tostring(mes) then
        local file = io.open("/storage/emulated/0/Documents/CApi.txt","w")
        file:write(mes)
        file:close()
        
        sendVariant({
          [0] = "OnAddNotification", 
          [1] = "interface/atomic_button.rttex", 
          [2] = "`2CApi : "..mes:upper(), 
          [3] = "audio/hub_open.wav", 
          [4] = {0}, 
        })
      end
      break
    else
      local file = io.open("/storage/emulated/0/Documents/CApi.txt","w")
      file:write("hello")
      file:close()
    end
  end
end

announcement()

AddHook("OnTextPacket", "a", pktfunc)
AddHook("OnVarlist", "b", varfunc)

logToConsole("\n`2[@AKM?] : CApi Is Loaded\nList Api? Just Type /api\nList Api Utility? Type /usage")

sleep(1000)

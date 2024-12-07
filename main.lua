local block_dialog=false function player()local tab={}function tab:px()return math.floor(getLocal().pos.x/32)end function tab:py()return math.floor(getLocal().pos.y/32)end function tab:reconnect()sendVariant({[0]="OnReconnect"},-1)end function tab:chat(txt)sendPacket(2,"action|input\n|text|"..txt)end function tab:wear(id)local pkt={}pkt.type=10 pkt.value=id sendPacketRaw(false,pkt)end function tab:warp(world,path)local looped=0 while getWorld().name~=world:upper()do looped=looped+1 sendPacket(3,"action|join_request\nname|"..world.."|\ninvitedWorld|0")sleep(1000)if looped==3 then logToConsole("Error Connection?")break end end if path~=nil then looped=0 if checkTile(math.floor(getLocal().pos.x/32),math.floor(getLocal().pos.y/32)).fg then while checkTile(math.floor(getLocal().pos.x/32),math.floor(getLocal().pos.y/32)).fg==6 do looped=looped+1 sendPacket(3,"action|join_request\nname|"..world.."|"..path.."\ninvitedWorld|0")sleep(1000)if looped==3 then logToConsole("Not Found Path/Error Connection?")break end end end end end function tab:tp(x,y)pkt={}pkt.type=0 pkt.value=32 pkt.x=x*32 pkt.y=y*32 sendPacketRaw(false,pkt)end function tab:drop(id,amount)sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..id.."|\ncount|"..amount.."\n")end function tab:trash(id,amount)sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..id.."|\ncount|"..amount.."\n")end function tab:pathfind(x,y)function astar(x,y,srad)function step()local dump={}for mx=0,srad-1 do for my=0,srad-1 do if checkPath(math.floor(getLocal().pos.x/32)-math.floor(srad/2)+mx,math.floor(getLocal().pos.y/32)-math.floor(srad/2)+my)then local jarax=math.abs((math.floor(getLocal().pos.x/32)-math.floor(srad/2)+mx)-x)local jaray=math.abs((math.floor(getLocal().pos.y/32)-math.floor(srad/2)+my)-y)table.insert(dump,{pos={x=math.floor(getLocal().pos.x/32)-math.floor(srad/2)+mx,y=math.floor(getLocal().pos.y/32)-math.floor(srad/2)+my},jarax=jarax,jaray=jaray})end end end local closest={pos={x=0,y=0},jarax=1000,jaray=1000}for i,v in pairs(dump)do doLog("List : "..v.jarax..","..v.jaray)if v.jarax<closest.jarax and v.jaray<closest.jaray then closest=v end end doLog("Closest : "..closest.jarax..","..closest.jaray)return closest end while true do local best=step()findPath(best.pos.x,best.pos.y)sleep(100)if math.floor(getLocal().pos.x/32)==x and math.floor(getLocal().pos.y/32)==y then break end end end end return tab end function players()local tab={}function tab:getbyname(name)for i,v in pairs(getPlayerlist())do if v.name:find(name)then local ptab={player=v}function ptab:pull()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/pull "..rawname)end function ptab:kick(ptab)local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/kick "..rawname)end function ptab:ban(ptab)local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/ban "..rawname)end return ptab end end return nil end function tab:getbyuserid(id)for i,v in pairs(getPlayerlist())do if v.userId==id then local ptab={player=v}function ptab:pull()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/pull "..rawname)end function ptab:kick()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/kick "..rawname)end function ptab:ban()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/ban "..rawname)end return ptab end end return nil end function tab:getbynetid(id)for i,v in pairs(getPlayerlist())do if v.netId==id then local ptab={player=v}function ptab:pull()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/pull "..rawname)end function ptab:kick()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/kick "..rawname)end function ptab:ban()local rawname=ptab.player.name:match("`%d(.+)``")sendPacket(2,"action|input\n|text|/ban "..rawname)end return ptab end end return nil end return tab end function inventory()local tab={}function tab:cbgl(bdialog)block_dialog=bdialog sendPacket(2,"action|dialog_return\ndialog_name|3898\nbuttonClicked|chc2_2_1\n")end function tab:dtap(id)pkt={}pkt.type=10 pkt.value=id sendPacketRaw(false,pkt)end function tab:check(id)for i,v in pairs(getInventory())do if v.id==id then return v.amount end end return 0 end return tab end function tile()local tab={}function tab:punch(x,y)pkt={}pkt.x=x*32 pkt.y=y*32 pkt.punchx=x pkt.punchy=y pkt.type=3 pkt.value=18 sendPacketRaw(false,pkt)end function tab:wrench(x,y)pkt={}pkt.x=x*32 pkt.y=y*32 pkt.punchx=x pkt.punchy=y pkt.type=3 pkt.value=32 sendPacketRaw(false,pkt)end function tab:place(x,y,id)pkt={}pkt.x=x*32 pkt.y=y*32 pkt.punchx=x pkt.punchy=y pkt.type=3 pkt.value=id sendPacketRaw(false,pkt)end return tab end function objects()local tab={}function tab:collect(id,delay)for i,v in pairs(getWorldObject())do if v.id==id and inventory():check(id)<200 then local pkt={}pkt.type=11 pkt.value=v.oid pkt.x=v.pos.x pkt.y=v.pos.y sendPacketRaw(false,pkt)sleep(delay)end end end function tab:cfloat(x,y,rad)local TotalAmount=0 for i,v in pairs(getWorldObject())do local jx=math.abs(v.pos.x/32-x)local jx=math.abs(v.pos.y/32-y)if jx<=rad and jy<=rad then if v.id==id then TotalAmount=TotalAmount+v.amount end end end return TotalAmount end function tab:cpos(x,y,id,rad)local CItem={}for i,v in pairs(getWorldObject())do if id~=nil then if v.id~=0 and v.id==id then local xdist=math.abs(v.pos.x/32-x)local ydist=math.abs(v.pos.y/32-y)if xdist<=rad and ydist<=rad then table.insert(CItem,v)end end else if v.id~=0 then local xdist=math.abs(v.pos.x/32-x)local ydist=math.abs(v.pos.y/32-y)if xdist<=rad and ydist<=rad then table.insert(CItem,v)end end end end if #CItem>0 then for i,v in pairs(CItem)do local pkt={}pkt.type=11 pkt.value=v.oid pkt.x=v.pos.x pkt.y=v.pos.y sendPacketRaw(false,pkt)end end end return tab end function log()local tab={}function tab:overlay(txt)var={}var[0]="OnTextOverlay" var[1]=txt sendVariant(var)end function tab:dialog(struct)var={}var[0]="OnDialogRequest" var[1]=struct sendVariant(var)end return tab end logToConsole("\n`2[@AKM?]: CApi Module Loaded...\n")function hook(var)if var[0]=="OnDialogRequest" then if block_dialog==true then block_dialog=false return true end end end if pcall(function()RemoveHook("var")end)then logToConsole("\n`2[@AKM?]: CApi Removing Old Hook...\n")end AddHook("OnVarlist","var",hook)logToConsole("\n`2[@AKM?]: CApi Block Dialog Loaded...\n")function announcement()while true do local file=io.open("/storage/emulated/0/Documents/CApi.txt","r")if file then local clientmes=file:read("*a")file:close()local mes=makeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/announcement.txt","GET").content if tostring(clientmes)~=tostring(mes)then local file=io.open("/storage/emulated/0/Documents/CApi.txt","w")file:write(mes)file:close()sendVariant({ [0]="OnAddNotification",[1]="interface/atomic_button.rttex",[2]="`2CApi : "..mes:upper(),[3]="audio/hub_open.wav",[4]={0},})end logToConsole("\n`2[@AKM?]: CApi Announcement Rendered...\n")break else local file=io.open("/storage/emulated/0/Documents/CApi.txt","w")file:write("𝖖𝖐𝖒ݖܰݖưݖ؝֍𝖊𝖗𝖊")file:close()logToConsole("\n`2[@AKM?]: CApi Making A New File...\n")end end end announcement()logToConsole("\n`2[@AKM?]: CApi Is Loaded...\n")

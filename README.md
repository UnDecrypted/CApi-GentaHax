<h2 align="center">Credit</h2>

[GentaHax Discord](https://discord.com/invite/genta7740)

[Satan Lua Discord](https://discord.com/invite/hEyMkPMj)

[My Skibidi Discord](https://discord.com/invite/Gd44CJYX)

<h2 align="center">What Is CApi?</h2>

> CApi Is Custom Api For Genta Hax Writen In Lua

<h2 align="center">Main Code</h2>

```
load(makeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/main.lua", "GET").content)()
```

> Just Copy And Paste The Code To Ur Script

<h2 align="center">List Of Custom Api</h2>

<h4 align="center">Player</h4>

#### Player Commands
|Function|Utility|
|-|-|
|px()|get player x|
|py()|get player y|
|reconnect()|to reconnect from server|
|chat(txt : str)|to make player chat|
|wear(id : int)|to set player clothes|
|warp(world : str,path : str)|warp world|
|tp(x : int,y : int)|to teleport player|
|drop(id : int,amount : int,delay : int,bdialog : bool)|to drop specific item|
|trash(id : int,amount : int,delay : amount,bdialog : bool)|to trash specific item|

<h4 align="center">Players</h4>

#### Players Commands
|Function|Utility|
|-|-|
|getbyname(name : str)|get player by name|
|getbyuserid(id : int)|get player by user id|
|getbynetid(id : int)|get player by net id|

#### Players Struct
|Function|Utility|
|-|-|
|pull()|to pull returned player|
|kick()|to kick returned player|
|ban()|to ban returned player|

<h4 align="center">Inventory</h4>

#### Inventory Commands
|Function|Utility|
|-|-|
|conbgl(bdialog : bool)|change dl to bgl|
|change(id : int)|to double tap item in inventory [wl/dl/bgl]|
|cinv(id : int)|get amount of item|

<h4 align="center">Tile</h4>

#### Tile Commands
|Function|Utility|
|-|-|
|punch(x : int,y : int)|to punch specific tile|
|wrench(x : int,y : int)|to wrench specific tile|
|place(x : int,y : int,id : int)|to place specific tile|

<h4 align="center">Objects</h4>

#### Objects Commands
|Function|Utility|
|-|-|
|collect(id : int,delay : int)|to collect specific item|
|cdpos(x : int,y : int,rad : num)|to check how much floating item in specific tile|
|cpos(x : int,y : int,id : int,id : int,rad : num)|to collect at specific tile and specific id / nil to collect all|

<h4 align="center">Log</h4>

#### Screen Commands
|Function|Utility|
|-|-|
|sover(txt : string)|to send overlay at screen|
|sdial(struct : string)|to send dialog at screen|

<h2 align="center">How To Use CApi</h2>

```
int = cinv(242) --Calling To Get Amount Item
doLog(int)  --Print It Out
```

> Just Try It So U Know How To Use It

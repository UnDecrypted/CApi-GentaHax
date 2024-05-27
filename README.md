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

#### Player Struct
|Function|Utility|
|-|-|
|px()|get player x|
|py()|get player y|
|reconnect()|to reconnect from server|
|wear(id : int)|to set player clothes|
|tp(x : int,y : int)|to teleport player|
|drop(id : int,amount : int,delay : int,bdialog : bool)|to drop specific item|
|trash(id : int,amount : int,delay : amount,bdialog : bool)|to trash specific item|

<h4 align="center">Players</h4>

#### Players Struct
|Function|Utility|
|-|-|
|getbyname(name : string)|get player by name :pull(),:kick(),:ban()|
|getbyuserid(id : int)|get player by user id :pull(),:kick(),:ban()|
|getbynetid(netid : int)|get player by net id :pull(),:kick(),:ban()|

<h4 align="center">Inventory</h4>

#### Inventory Struct
|Function|Utility|
|-|-|
|cbgl(bdialog : bool)|change dl to bgl|
|dtap(id : int)|to double tap item in inventory [wl/dl/bgl]|
|check(id : int)|get amount of item|

<h4 align="center">Tile</h4>

#### Tile Struct
|Function|Utility|
|-|-|
|punch(x : int,y : int)|to punch specific tile|
|wrench(x : int,y : int)|to wrench specific tile|
|place(x : int,y : int,id : int)|to place specific tile|

<h4 align="center">Objects</h4>

#### Tile Struct
|Function|Utility|
|-|-|
|collect(id : int,delay : int)|to collect specific item|
|cfloat(x : int,y : int,rad : num)|to check how much floating item in specific tile|
|collectpos(x : int,y : int,id : int,id : int,rad : num)|to collect at specific tile and specific id / nil to collect all|

<h4 align="center">Log</h4>

#### Tile Struct
|Function|Utility|
|-|-|
|overlay(txt : string)|to send overlay at screen|
|dialog(struct : string)|to send dialog at screen|

<h2 align="center">How To Use CApi</h2>

```
int = inventory():check(242)
doLog(int)
```

> Just Try It So U Know How To Use It

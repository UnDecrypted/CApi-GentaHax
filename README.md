<h4 align="center">Credit</h4>

[GentaHax Discord](https://discord.com/invite/genta7740)

[Satan Lua Discord](https://discord.com/invite/hEyMkPMj)

[My Skibidi Discord](https://discord.com/invite/Gd44CJYX)

<h4 align="center">What Is CApi?</h4>

> CApi Is Custom Api For Genta Hax Writen In Lua

<h4 align="center">Main Code</h4>

```
load(makeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/main.lua", "GET").content)()
```

> Just Copy And Paste The Code To Ur Script

<h4 align="center">List Of Custom Api</h4>

<h2 align="center">Player</h2>

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

<h2 align="center">Inventory</h2>

#### Inventory Struct
|Function|Utility|
|-|-|
|cbgl(bdialog : bool)|change dl to bgl|
|dtap(id)|to double tap item in inventory [wl/dl/bgl]|
|check(id)|get amount of item|

<h4 align="center">How To Use CApi</h4>

```
int = cinv(242)
doLog(int)
```

> Just Try It So U Know How To Use It

<h4 align="center">What Is CApi?</h4>

> CApi Is Custom Api For Genta Hax Writen In Lua

<h4 align="center">Main Code</h4>

```
load(makeRequest("https://raw.githubusercontent.com/UnDecrypted/CApi-GentaHax/main/main.lua", "GET").content)()
```

> Just Copy And Paste The Code To Ur Script

<h4 align="center">List Of Custom Api</h4>

```
{
  {
    api : cinv(int id)
    return : int
    usage : to get amount of item in inventory
  }
  {
    api : punch(int x, int y)
    return : none
    usage : to punch tile in specific x and y
  }
  {
    api : wrench(int x, int y)
    return : none
    usage : to wrench tile in specific x and y
  }
  {
    api : place(int x, int y, int block id)
    return : none
    usage : to place tile in specific x, y and block id
  }
  {
    api : drop(int id, int amount, int delay)
    return : none
    usage : to drop item from inventory
  }
  {
    api : cdpos(int x, int y, number radius)
    return : int
    usage : to get amount of floatijg item in specific tile, radius is detect range of item
  }
  {
    api : cpos(int x, int y, int id, number radius)
    return : none
    usage : to collect floating item in specific x, y, id / nil to collect all and radius is detect range of item
  }
}
```

<h4 align="center">How To Use CApi</h4>

```
int = capi.cinv(242)
doLog(int)
```

> Just Try It So U Know How To Use It

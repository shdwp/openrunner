## What's this?
__openrunner__ is an open-source _Android: Netrunner_ implementation written in __C++__/__OpenGL__/__Lua__. Currently in early stages on development.

![](https://i.imgur.com/mQ4TX9h.png)

## Implementation
Engine is written in _C++_, while actual game logic is written in OOP _Lua_, for which engine provides bindings. 
Most of the game mechanics are implemented, as well as ~40% of core set cards. Bare minimum of player UI is implemented, with next major thing to be done being AI.

## Directory Structure
* `/app` is netrunner-specific code as well as glfw application boilerplate
  * `/app/scripts` is where `lua` resides, implementing most of the actual netrunner rules
    * `/app/scripts/db/packs` - cards information in `lua` format, as well as card-specific rules implementation
* `/extern` - third-party dependencies
* `/include` - game engine header files
* `/src` - game engine source files

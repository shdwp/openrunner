//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_LUAHOST_H
#define OPENRUNNER_LUAHOST_H

#include <lua.hpp>

class LuaHost {
private:
    lua_State *L;

    ~LuaHost() {
        lua_close(L);
    }

public:
    explicit LuaHost() {
        L = luaL_newstate();
        luaL_openlibs(L);
    }
};


#endif //OPENRUNNER_LUAHOST_H

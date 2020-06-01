//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_LUAHOST_H
#define OPENRUNNER_LUAHOST_H

#include <definitions.h>
#include <lua.hpp>
#include <LuaBridge/LuaBridge.h>

class LuaHost {
private:

    static void Move(LuaHost *a, LuaHost &b) {
        a->L = b.L;
        b.L = nullptr;
    }

    void bridgeEngine();

public:
    lua_State *L;

    explicit LuaHost() {
        L = luaL_newstate();
        luaL_openlibs(L);
        this->bridgeEngine();
    }

    LuaHost(LuaHost &&o) noexcept {
        Move(this, o);
    }

    LuaHost& operator=(LuaHost &&o) noexcept {
        Move(this, o);
        return *this;
    }

    ~LuaHost() {
        lua_close(L);
    }

    void doFile(const string&);

    luabridge::Namespace ns() {
        return luabridge::getGlobalNamespace(L);
    }

    template <class T>
    void setGlobal(const string &name, T *ptr) {
        luabridge::push(L, ptr);
        lua_setglobal(L, name.c_str());
    }

    luabridge::LuaRef getGlobal(const string &name) {
        return luabridge::getGlobal(L, name.c_str());
    }
};


#endif //OPENRUNNER_LUAHOST_H

//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_LUAHOST_H
#define OPENRUNNER_LUAHOST_H

#include <definitions.h>
#include <lua.hpp>
#include <LuaBridge/LuaBridge.h>
#include <debugger_lua.h>

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
        INFO("LuaHost {:x} newstate luaL {:x}", (size_t)this, (size_t)L);

        luaL_openlibs(L);
        dbg_setup_default(L);

        this->doFile("../app/scripts_lib/native_interface_engine.lua");
        this->bridgeEngine();;
    }

    LuaHost(const LuaHost &) = delete;

    LuaHost(LuaHost &&o) noexcept {
        Move(this, o);
    }

    LuaHost& operator=(LuaHost &&o) noexcept {
        Move(this, o);
        return *this;
    }

    ~LuaHost() {
        INFO("LuaHost {:x} closed luaL {:x}", (size_t)this, (size_t)L);
        lua_close(L);
    }

    void doFile(const string&);

    template <typename P1>
    luabridge::LuaRef doFunction(const luabridge::LuaRef& ref, P1 p1) {
        ref.push();
        luabridge::Stack<P1>::push(L, p1);
        dbg_pcall(L, 1, 1, 0);
        return luabridge::LuaRef::fromStack(L);
    }

    template <typename P1, typename P2>
    luabridge::LuaRef doFunction(const luabridge::LuaRef& ref, P1 p1, P2 p2) {
        ref.push();
        luabridge::Stack<P1>::push(L, p1);
        luabridge::Stack<P2>::push(L, p2);
        dbg_pcall(L, 2, 1, 0);
        return luabridge::LuaRef::fromStack(L);
    }

    template <typename P1, typename P2, typename P3>
    luabridge::LuaRef doFunction(const luabridge::LuaRef& ref, P1 p1, P2 p2, P3 p3) {
        ref.push();
        luabridge::Stack<P1>::push(L, p1);
        luabridge::Stack<P2>::push(L, p2);
        luabridge::Stack<P3>::push(L, p3);
        dbg_pcall(L, 3, 1, 0);
        return luabridge::LuaRef::fromStack(L);
    }

    template <typename P1, typename P2, typename P3, typename P4>
    luabridge::LuaRef doFunction(const luabridge::LuaRef& ref, P1 p1, P2 p2, P3 p3, P4 p4) {
        ref.push();
        luabridge::Stack<P1>::push(L, p1);
        luabridge::Stack<P2>::push(L, p2);
        luabridge::Stack<P3>::push(L, p3);
        luabridge::Stack<P4>::push(L, p4);
        dbg_pcall(L, 4, 1, 0);
        return luabridge::LuaRef::fromStack(L);
    }

    void printTraceback() {
        lua_getglobal(L, "debug");
        lua_pushstring(L, "traceback");
        lua_gettable(L, -2);
        lua_pcall(L, 0, 1, 0);
        ERROR(lua_tostring(L, -1));
        lua_pop(L, 1);
    }

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

    luabridge::LuaRef createTable() {
        return luabridge::LuaRef::newTable(L);
    }
};


#endif //OPENRUNNER_LUAHOST_H

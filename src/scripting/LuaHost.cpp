//
// Created by shdwp on 5/22/2020.
//

#include "scripting/LuaHost.h"
#include <ui/Input.h>
#include <util/Debug.h>

using namespace luabridge;

void LuaHost::doFile(const string &a) {
    int ret;

    do {
        if ((ret = luaL_loadfile(L, a.c_str())) != 0) {
            break;
        }

        if ((ret = lua_pcall(L, 0, LUA_MULTRET, 0)) != 0) {
            break;
        }
    } while (false);

    if (ret != 0) {
        ERROR("Lua {}", lua_tostring(L, -1));
        lua_pop(L, 1);
    }
}

void LuaHost::bridgeEngine() {
    {
        ns()
                .beginClass<Input>("_input")
                .addProperty("cursorX", &Input::getCursorX)
                .addProperty("cursorY", &Input::getCursorY)
                .addFunction("keyDown", &Input::keyDown)
                .addFunction("keyPressed", &Input::keyPressed)
                .endClass();

        setGlobal("Input", Input::Shared);
    }

    {
        ns()
                .beginClass<glm::vec3>("Vec3")
                .addConstructor<void(*) (float, float, float)>()
                .addProperty("x", std::function([](const glm::vec3 *vec) {return vec->x;}), std::function([](glm::vec3 *vec, float x) {vec->x = x;}))
                .addProperty("y", std::function([](const glm::vec3 *vec) {return vec->y;}), std::function([](glm::vec3 *vec, float y) {vec->y = y;}))
                .addProperty("z", std::function([](const glm::vec3 *vec) {return vec->z;}), std::function([](glm::vec3 *vec, float z) {vec->z = z;}))
                .endClass();
    }

    {
        ns()
                .beginClass<Camera>("Camera")
                .addProperty("position", &Camera::position)
                .addProperty("direction", &Camera::direction)
                //.addProperty("position", std::function([](const Camera *cam) {return cam->position; }))
                //.addProperty("direction", std::function([](const Camera *cam) {return cam->position; }))
                .endClass();
    }

    {
        ns()
                .beginClass<Debug>("_debug")
                .endClass();

        setGlobal("Debug", Debug::Shared);
    }
}


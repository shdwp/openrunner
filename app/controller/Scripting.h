//
// Created by shdwp on 5/31/2020.
//

#ifndef OPENRUNNER_SCRIPTING_H
#define OPENRUNNER_SCRIPTING_H

#include <scripting/LuaHost.h>

class Scripting {
private:
    unique_ptr<LuaHost> host_;
    unique_ptr<vector<luabridge::LuaRef>> init_handles_;
    unique_ptr<vector<luabridge::LuaRef>> tick_handles_;

    void doModule(const string &path, const string &name);

public:
    explicit Scripting();

    void registerClasses();

    template <class T>
    void setGlobal(const string &name, T *ptr) {
        host_->setGlobal(name, ptr);
    }

    void doScripts(const string &base_path);

    void onInit() {
        for (auto &h: *init_handles_) {
            host_->doFunction(h);
        }
    }

    void onTick(double dt) {
        for (auto &h : *tick_handles_) {
            host_->doFunction(h, dt);
        }
    }
};


#endif //OPENRUNNER_SCRIPTING_H

//
// Created by shdwp on 5/31/2020.
//

#include "Scripting.h"
#include "dirent.h"
#include "../model/board/GameBoard.h"

Scripting::Scripting() {
    host_ = make_unique<LuaHost>();
    tick_handles_ = make_unique<vector<luabridge::LuaRef>>();
    init_handles_ = make_unique<vector<luabridge::LuaRef>>();

    Card::luaRegister(host_->ns());
    GameBoard::luaRegister(host_->ns());
    GameBoardView::luaRegister(host_->ns());
    StackWidget::luaRegister(host_->ns());
}

void Scripting::doScripts(const string &base_path) {
    struct dirent *entry;
    DIR *handle = opendir(base_path.c_str());
    ASSERT(handle, "Failed to open base_path");

    while ((entry = readdir(handle))) {
        auto filename = string(entry->d_name);
        auto path = base_path + "/" + filename;

        if (path.compare(path.length() - 4, 4, ".lua") == 0) {
            auto module_name = filename.substr(0, filename.length() - 4);

            this->doModule(path, module_name);
        }
    }

    closedir(handle);
}

void Scripting::doModule(const string &path, const string &name) {
    host_->doFile(path);
    auto descr_table = host_->getGlobal(name);

    auto tick_handle = descr_table["onTick"];
    auto init_handle = descr_table["onInit"];

    if (!tick_handle.isNil()) {
        tick_handles_->emplace_back(tick_handle);
    }

    if (!init_handle.isNil()) {
        init_handles_->emplace_back(init_handle);
    }
}

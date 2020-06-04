//
// Created by shdwp on 5/31/2020.
//

#include "Scripting.h"
#include "dirent.h"

#include "../model/board/GameBoard.h"
#include "../view/board/CardDeckView.h"

Scripting::Scripting() {
    host_ = make_unique<LuaHost>();
    tick_handles_ = make_unique<vector<luabridge::LuaRef>>();
    init_handles_ = make_unique<vector<luabridge::LuaRef>>();
}

void Scripting::registerClasses() {
    // GameBoard
    {
        host_->ns()
                .beginClass<GameBoard>("GameBoard")
                .addFunction("cardInsert", &GameBoard::insert<Card, CardView>)
                .addFunction("cardAppend", &GameBoard::append<Card, CardView>)
                .addFunction("deckInsert", &GameBoard::insert<CardDeck, CardDeckView>)
                .addFunction("deckAppend", &GameBoard::append<CardDeck, CardDeckView>)

                .addFunction("erase", &GameBoard::erase)

                .addFunction("cardReplace", &GameBoard::replace<Card, CardView>)
                .addFunction("deckReplace", &GameBoard::replace<Card, CardView>)

                .addFunction("cardGet", &GameBoard::get<Card>)
                .addFunction("deckGet", &GameBoard::get<CardDeck>)
                .endClass();
    }

    // Card
    {
        host_->ns()
                .beginClass<Card>("Card")
                .addConstructor<void(*) (int, bool)>()
                .addProperty("uid", &Card::uid)
                .addProperty("faceup", &Card::faceup)
                .addProperty("variant", &Card::variant)
                .endClass();
    }

    // CardDeck
    {
        host_->ns()
                .beginClass<CardDeck>("CardDeck")
                .addConstructor<void(*) (void)>()
                .addFunction("top", &CardDeck::top)
                .addFunction("takeTop", &CardDeck::takeTop)
                .addFunction("takeBottom", &CardDeck::takeBottom)
                .addFunction("insert", &CardDeck::insert)
                .addFunction("append", &CardDeck::append)
                .addFunction("remove", &CardDeck::remove)
                .endClass();
    }

    // GameBoardView
    {
        host_->ns()
                .beginClass<GameBoardView>("GameBoardView")
                .addFunction("getSlotStackWidget", &GameBoardView::getUnownedSlotView<StackWidget>)
                .endClass();
    }

    // StackWidget
    {
        struct helper {
            static int getOrientation(StackWidget const *widget) { return widget->orientation; }
            static int getAlignment(StackWidget const *widget) { return widget->alignment; }
            static void setOrientation(StackWidget *widget, int orientation) { widget->orientation = (stack_widget_orientation_t) orientation; }
            static void setAlignment(StackWidget *widget, int alignment) { widget->alignment = (stack_widget_alignment_t) alignment; }
            static float getPadding(StackWidget const *widget) { return widget->child_padding; }
            static float getRotation(StackWidget const *widget) { return widget->child_rotation; }
            static void setPadding(StackWidget *widget, float padding) { widget->child_padding = padding; }
            static void setRotation(StackWidget *widget, float rot) { widget->child_rotation = rot; }
        };

        host_->ns()
                .beginClass<StackWidget>("StackWidget")
                .addProperty("orientation", &helper::getOrientation, &helper::setOrientation)
                .addProperty("alignment", &helper::getAlignment, &helper::setAlignment)
                .addProperty("child_padding", &helper::getPadding, &helper::setPadding)
                .addProperty("child_rotation", &helper::getRotation, &helper::setRotation)
                .endClass();
    }
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

            try {
                this->doModule(path, module_name);
            } catch (luabridge::LuaException &ex) {
                ERROR("Failed to load module {}", path);
            }
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

//
// Created by shdwp on 5/31/2020.
//

#include "Scripting.h"
#include <render/Label.h>
#include <ui/Input.h>

#include "dirent.h"

#include "../model/board/GameBoard.h"
#include "../view/board/DeckView.h"
#include "../view/widgets/CardSelectWidget.h"

#define TYPE_PROP(n) addProperty("type", std::function<string (const n *)>([](const n *) {return string(#n); }))

void Scripting::registerClasses() {
    host_->setGlobal("libpath", "../app/scripts_lib/");

    // GameBoard
    {
        host_->ns()
                .beginClass<GameBoard>("GameBoard")
                .TYPE_PROP(GameBoard)
                .addFunction("cardInsert", &GameBoard::insert<Card, CardView>)
                .addFunction("cardAppend", &GameBoard::append<Card, CardView>)
                .addFunction("deckInsert", &GameBoard::insert<Deck, DeckView>)
                .addFunction("deckAppend", &GameBoard::append<Deck, DeckView>)

                .addFunction("cardPop", &GameBoard::pop<Card>)
                .addFunction("deckPop", &GameBoard::pop<Deck>)

                .addFunction("cardReplace", &GameBoard::replace<Card, Card, CardView>)
                .addFunction("deckReplace", &GameBoard::replace<Deck, Deck, DeckView>)

                .addFunction("cardGet", &GameBoard::get<Card>)
                .addFunction("deckGet", &GameBoard::get<Deck>)

                .addFunction("count", &GameBoard::count)
                .endClass();
    }

    // Card
    {
        host_->ns()
                .beginClass<Card>("Card")
                .TYPE_PROP(Card)
                .addConstructor<void(*) (int, luabridge::LuaRef)>()
                .addProperty("uid", &Card::uid)
                .addProperty("faceup", &Card::faceup)
                .addProperty("variant", &Card::variant)
                .addProperty("meta", &Card::meta)
                .endClass();
    }

    // Deck
    {
        host_->ns()
                .beginClass<Deck>("Deck")
                .TYPE_PROP(Deck)
                .addConstructor<void(*) (void)>()
                .addFunction("top", &Deck::topUnowned)
                .addFunction("takeTop", &Deck::takeTop)
                .addFunction("takeBottom", &Deck::takeBottom)
                .addFunction("insert", &Deck::insert)
                .addFunction("append", &Deck::append)
                .addFunction("shuffle", &Deck::shuffle)
                .addFunction("remove", &Deck::remove)
                .addFunction("erase", &Deck::erase)
                .addProperty("size", &Deck::size)
                .endClass();
    }

    // GameBoardView
    {
        host_->ns()
                .beginClass<GameBoardView>("GameBoardView")
                .TYPE_PROP(GameBoardView)
                .addProperty("vertical_offset", std::function([](const GameBoardView *ptr) {return ptr->position.y;}), std::function([](GameBoardView *ptr, float val) { ptr->position.y = val; }))
                .addFunction("getSlotStackWidget", &GameBoardView::getUnownedSlotView<StackWidget>)
                .endClass();
    }

    // SlotView
    {
        host_->ns()
                .beginClass<SlotView>("SlotView")
                .addProperty("slot", &SlotView::slotid, false)
                .endClass();
    }


    // CardView
    {
        host_->ns()
                .deriveClass<CardView, SlotView>("CardView")
                .TYPE_PROP(CardView)
                .addProperty("card", &CardView::getUnownedCardPtr)
                .endClass();
    }

    // DeckView
    {
        host_->ns()
                .deriveClass<DeckView, SlotView>("DeckView")
                .TYPE_PROP(DeckView)
                .addProperty("deck", &DeckView::getUnownedDeckPtr)
                .endClass();
    }

    // StackWidget
    {
        struct helper {
            static string getOrientation(StackWidget const *widget) {
                switch (widget->orientation) {
                    case StackWidgetOrientation_Vertical:
                        return "vertical";
                    case StackWidgetOrientation_Horizontal:
                        return "horizontal";
                }

                FAIL("Enum error");
                return "";
            }

            static string getAlignment(StackWidget const *widget) {
                switch (widget->alignment) {
                    case StackWidgetAlignment_Min:
                        return "min";
                    case StackWidgetAlignment_Max:
                        return "max";
                }

                FAIL("Enum error");
                return "";
            }

            static void setOrientation(StackWidget *widget, const string &orientation) {
                if (orientation == "vertical") {
                    widget->orientation = StackWidgetOrientation_Vertical;
                } else if (orientation == "horizontal") {
                    widget->orientation = StackWidgetOrientation_Horizontal;
                } else {
                    // @TODO: raise lua error
                }
            }

            static void setAlignment(StackWidget *widget, const string &alignment) {
                if (alignment == "min") {
                    widget->alignment = StackWidgetAlignment_Min;
                } else if (alignment == "max") {
                    widget->alignment = StackWidgetAlignment_Max;
                } else {
                    // @TODO: raise lua error
                }
            }

            static float getPadding(StackWidget const *widget) { return widget->child_padding; }
            static float getRotation(StackWidget const *widget) { return widget->child_rotation; }
            static void setPadding(StackWidget *widget, float padding) { widget->child_padding = padding; }
            static void setRotation(StackWidget *widget, float rot) { widget->child_rotation = rot; }
        };

        host_->ns()
                .beginClass<StackWidget>("StackWidget")
                .TYPE_PROP(StackWidget)
                .addProperty("orientation", &helper::getOrientation, &helper::setOrientation)
                .addProperty("alignment", &helper::getAlignment, &helper::setAlignment)
                .addProperty("child_padding", &helper::getPadding, &helper::setPadding)
                .addProperty("child_rotation", &helper::getRotation, &helper::setRotation)
                .endClass();
    }

    // SlotInteractable
    {
        host_->ns()
                .beginClass<SlotInteractable>("SlotInteractable")
                .TYPE_PROP(SlotInteractable)
                .addProperty("slot", &SlotInteractable::slotid)
                .endClass();
    }

    // OptionInteractable
    {
        host_->ns()
                .beginClass<OptionInteractable>("OptionInteractable")
                .TYPE_PROP(OptionInteractable)
                .addProperty("index", &OptionInteractable::index)
                .endClass();
    }

    // Label
    {
        host_->ns()
                .beginClass<Label>("Label")
                .TYPE_PROP(Label)
                .addFunction("setText", &Label::setText)
                .endClass();
    }

    // CardSelectWidget
    {
        host_->ns()
                .beginClass<CardSelectWidget>("CardSelectWidget")
                .TYPE_PROP(CardSelectWidget)
                .addFunction("setDeck", &CardSelectWidget::setDeck)
                .addFunction("removeCard", &CardSelectWidget::removeCard)
                .addProperty("hidden",
                             std::function([](const CardSelectWidget *ptr) { return ptr->hidden; }),
                             std::function([](CardSelectWidget *ptr, bool value) { ptr->hidden = value; }))
                .endClass();
    }

    // OptionSelectWidget
    {
        host_->ns()
                .beginClass<OptionSelectWidget>("OptionSelectWidget")
                .TYPE_PROP(OptionSelectWidget)
                .addFunction("setOptions", &OptionSelectWidget::setOptions)
                .addProperty("hidden",
                             std::function([](const OptionSelectWidget *ptr) { return ptr->hidden; }),
                             std::function([](OptionSelectWidget *ptr, bool value) { ptr->hidden = value; }))
                .endClass();
    }

    // lib
    {
        host_->ns()
                .beginClass<Scripting>("Scripting")
                .TYPE_PROP(Scripting)
                .addFunction("log", &Scripting::log)
                .addFunction("register", &Scripting::registerController)
                .endClass();
    }
}

void Scripting::doScripts(const string &base_path) {
    struct dirent *entry;
    DIR *handle = opendir(base_path.c_str());
    ASSERT(handle, "Failed to open base_path");

    vector<string> names;
    while ((entry = readdir(handle))) {
        auto name = string(entry->d_name);
        if (name.find('.') == string::npos) {
            names.emplace_back(name);
        } else{
            names.emplace(names.begin(), name);
        }
    }

    for (auto &filename : names) {
        auto path = format("{}/{}", base_path, filename);

        if (filename.find('.') == string::npos) {
            doScripts(path);
        } else if (path.compare(path.length() - 4, 4, ".lua") == 0) {
            auto module_name = filename.substr(0, filename.length() - 4);

            try {
                this->doScript(path);
            } catch (luabridge::LuaException &ex) {
                ERROR("Failed to load module {}", path);
            }
        }
    }

    closedir(handle);
}

void Scripting::doScript(const string &path) {
    host_->doFile(path);
}

void Scripting::registerController(const luabridge::LuaRef &descr_table) {
    auto tick_handle = descr_table["onTick"];
    auto init_handle = descr_table["onInit"];
    auto intr_handle = descr_table["onInteraction"];

    if (!tick_handle.isNil()) {
        tick_handles_->emplace_back(std::tuple(descr_table, tick_handle));
    }

    if (!init_handle.isNil()) {
        init_handles_->emplace_back(std::tuple(descr_table, init_handle));
    }

    if (!intr_handle.isNil()) {
        interaction_handles_->emplace_back(std::tuple(descr_table, intr_handle));
    }
}

void Scripting::reset() {
    tick_handles_->erase(begin(*tick_handles_), end(*tick_handles_));
    init_handles_->erase(begin(*init_handles_), end(*init_handles_));
    interaction_handles_->erase(begin(*interaction_handles_), end(*interaction_handles_));
}

void Scripting::log(const int level, const string &str) {
    auto line = string("Lua ");
    switch (level) {
        case 0: line.append("E: "); break;
        case 1: line.append("I: "); break;
        case 2: line.append("V: "); break;
        default: break;
    }

    line.append(str);

    switch (level) {
        case 0: {
            ERROR(line);
            host_->printTraceback();
            break;
        }
        case 1:
            INFO(line);
            break;
        case 2:
            VERBOSE(line);
            break;
        default:
            FAIL("Invalid enum");
            break;
    }
}

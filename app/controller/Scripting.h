//
// Created by shdwp on 5/31/2020.
//

#ifndef OPENRUNNER_SCRIPTING_H
#define OPENRUNNER_SCRIPTING_H

#include <scripting/LuaHost.h>
#include <ui/UILayer.h>

#include "../view/board/SlotInteractable.h"
#include "../view/board/DeckView.h"

enum InteractionEvent {
    InteractionEvent_Click,
    InteractionEvent_AltClick,
    InteractionEvent_Drag,
    InteractionEvent_Release,
};

typedef enum InteractionEvent interaction_event_t;

typedef vector<std::tuple<luabridge::LuaRef, luabridge::LuaRef>> scripting_handles_t;

class Scripting {
private:
    unique_ptr<LuaHost> host_ = make_unique<LuaHost>();
    unique_ptr<scripting_handles_t> init_handles_ = make_unique<scripting_handles_t>();
    unique_ptr<scripting_handles_t> tick_handles_ = make_unique<scripting_handles_t>();
    unique_ptr<scripting_handles_t> interaction_handles_ = make_unique<scripting_handles_t>();

    void doModule(const string &path, const string &name);

public:
    Scripting() {}

    void registerClasses();

    template <unsigned int level>
    void log(const string &str) {
        auto line = string("Lua ");
        switch (level) {
            case 0: line.append("E: "); break;
            case 1: line.append("I: "); break;
            case 2: line.append("V: "); break;
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
        }
    }

    template <class T>
    void setGlobal(const string &name, T *ptr) {
        host_->setGlobal(name, ptr);
    }

    void doScripts(const string &base_path);

    void onInit() {
        for (auto &h: *init_handles_) {
            host_->doFunction(std::get<1>(h), std::get<0>(h));
        }
    }

    void onTick(double dt) {
        for (auto &h : *tick_handles_) {
            host_->doFunction(std::get<1>(h), std::get<0>(h), dt);
        }
    }

    template <class T>
    void onInteraction(interaction_event_t event, shared_ptr<T> object = nullptr) {
        string event_str;
        switch (event) {
            case InteractionEvent_Click: event_str = "click"; break;
            case InteractionEvent_AltClick: event_str = "altclick"; break;
            case InteractionEvent_Drag: event_str = "drag"; break;
            case InteractionEvent_Release: event_str = "release"; break;
            default: FAIL("Enum error");
        }

        for (auto &h : *interaction_handles_) {
            if (auto slot = dynamic_cast<SlotInteractable *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, slot);
            } else if (auto deckview = dynamic_cast<DeckView *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, deckview);
            } else if (auto cardview = dynamic_cast<CardView *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, cardview);
            }
        }
    }
};


#endif //OPENRUNNER_SCRIPTING_H

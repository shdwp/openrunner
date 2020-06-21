//
// Created by shdwp on 5/31/2020.
//

#ifndef OPENRUNNER_SCRIPTING_H
#define OPENRUNNER_SCRIPTING_H

#include <scripting/LuaHost.h>
#include <ui/UILayer.h>

#include "../view/board/SlotInteractable.h"
#include "../view/board/DeckView.h"
#include "../view/widgets/OptionSelectWidget.h"

enum InteractionEvent {
    InteractionEvent_Primary,
    InteractionEvent_Secondary,
    InteractionEvent_Tertiary,
    InteractionEvent_Drag,
    InteractionEvent_Release,
    InteractionEvent_Cancel,
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

    void log(int level, const string &str);

    template <class T>
    void setGlobal(const string &name, T *ptr) {
        host_->setGlobal(name, ptr);
    }

    luabridge::LuaRef getGlobal(const string &name) {
        return host_->getGlobal(name);
    }

    void doScripts(const string &base_path);

    void doScript(const string &path);

    void registerController(const luabridge::LuaRef &descr_table);

    void reset();

    template <class T>
    string debugMetadataDescription(T *ptr) {
        auto ref = host_->getGlobal("debugDescription");
        try {
            return ref(ptr);
        } catch (luabridge::LuaException &ex) {
            return "fail";
        }
    }

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
            case InteractionEvent_Primary: event_str = "primary"; break;
            case InteractionEvent_Secondary: event_str = "secondary"; break;
            case InteractionEvent_Tertiary: event_str = "tertiary"; break;
            case InteractionEvent_Drag: event_str = "drag"; break;
            case InteractionEvent_Release: event_str = "release"; break;
            case InteractionEvent_Cancel: event_str = "cancel"; break;
            default: FAIL("Enum error");
        }

        for (auto &h : *interaction_handles_) {
            if (auto slot = dynamic_cast<SlotInteractable *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, slot);
            } else if (auto option = dynamic_cast<OptionInteractable *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, option);
            } else if (auto deckview = dynamic_cast<DeckView *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, deckview);
            } else if (auto cardview = dynamic_cast<CardView *>(object.get())) {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str, cardview);
            } else {
                host_->doFunction(std::get<1>(h), std::get<0>(h), event_str);
            }
        }
    }
};


#endif //OPENRUNNER_SCRIPTING_H

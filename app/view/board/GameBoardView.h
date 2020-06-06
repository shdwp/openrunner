//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_GAMEBOARDVIEW_H
#define OPENRUNNER_GAMEBOARDVIEW_H


#include <engine/Entity.h>
#include <unordered_map>
#include <engine/Scene.h>

#include "CardView.h"
#include "SlotInteractable.h"
#include "../widgets/StackWidget.h"

class GameBoardView: public Entity {
private:
    unique_ptr<std::unordered_map<string, glm::vec3>> slot_positions_ = make_unique<std::unordered_map<string, glm::vec3>>();
    unique_ptr<std::unordered_map<string, glm::vec4>> slot_bounding_boxes_ = make_unique<std::unordered_map<string, glm::vec4>>();
    unique_ptr<std::unordered_map<string, shared_ptr<SlotInteractable>>> slot_interactables_ = make_unique<std::unordered_map<string, shared_ptr<SlotInteractable>>>();

public:
    explicit GameBoardView(shared_ptr<Model> model);
    GameBoardView();

    void addModelSlots();
    void addSlot(const string& slotid, glm::vec3 pos, glm::vec4 bbox = glm::vec4(-1, -1, 1, 1));

    [[nodiscard]] bool hasSlot(const string& slotid) const;

    template <typename T>
    shared_ptr<T> addSlotView(const string& slotid, T &&view) {
        auto child = this->addChild(move(view));
        child->slotid = slotid;

        if (auto stack_ptr = dynamic_pointer_cast<StackWidget>(child)) {
            stack_ptr->bounding_box = (*slot_bounding_boxes_)[slotid];
        } else {
            child->position = (*slot_positions_)[slotid];
        }

        return child;
    }

    template<typename T>
    shared_ptr<T> getSlotView(const string& slotid) const {
        for (auto &_child : *children_) {
            auto child = std::dynamic_pointer_cast<SlotView>(_child);
            if (child != nullptr && child->slotid == slotid) {
                return std::dynamic_pointer_cast<T>(_child);
            }
        }

        return nullptr;
    }

    template<typename T>
    T *getUnownedSlotView(const string &slotid) const {
        for (auto &_child : *children_) {
            auto child = std::dynamic_pointer_cast<SlotView>(_child);
            if (child != nullptr && child->slotid == slotid) {
                return dynamic_cast<T *>(_child.get());
            }
        }

        return nullptr;
    }

    void removeSlotView(const string& slotid, int idx = 0);

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_GAMEBOARDVIEW_H

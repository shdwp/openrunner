//
// Created by shdwp on 5/22/2020.
//

#include "GameBoardView.h"
#include <util/Debug.h>

#include "../widgets/StackWidget.h"

GameBoardView::GameBoardView(shared_ptr<Model> model): Entity::Entity(model) {
    slot_positions_ = make_unique<std::unordered_map<string, glm::vec3>>();
    slot_bounding_boxes_ = make_unique<std::unordered_map<string, glm::vec4>>();

    for (auto &zone : *model->zones) {
        auto a = glm::vec3(zone.box.x, 0.04f, zone.box.y);
        auto b = glm::vec3(zone.box.z, 0.04f, zone.box.w);

        auto pos = ((b - a) * 0.5f) + a;
        this->addSlot(zone.identifier, pos, zone.box);
    }
}

void GameBoardView::addSlot(const string& slotid, glm::vec3 pos, glm::vec4 bbox) {
    auto map = *slot_positions_;
    (*slot_positions_)[slotid] = pos;
    (*slot_bounding_boxes_)[slotid] = bbox;
}

void GameBoardView::addCardView(const string& slotid, CardView &view) {
    view.slotid = slotid;
    view.position = (*slot_positions_)[slotid];
    if (auto stack = dynamic_cast<StackWidget *>(&view)) {
        stack->bounding_box = (*slot_bounding_boxes_)[slotid];
        // @TODO: redo to arrive at single addChild
        this->addChild(make_shared<StackWidget>(move(*stack)));
    } else {
        this->addChild(make_shared<CardView>(move(view)));
    }
}

void GameBoardView::removeCardView(const string& slotid, int idx) {
    for (auto &_child : *children_) {
        auto child = dynamic_pointer_cast<CardView>(_child);
        if (child->slotid == slotid) {
            this->removeChild(_child);
            break;
        }
    }
}

void GameBoardView::update() {
    Entity::update();
}

void GameBoardView::draw(glm::mat4 transform) {
    Entity::draw(transform);

    for (auto &vec : *slot_bounding_boxes_) {
        auto zone = vec.second;
        Debug::Shared()->drawArea(
                glm::vec3(zone.x, 0.0f, zone.y),
                glm::vec3(zone.z, 0.0f, zone.w),
                transform
        );
    }

}

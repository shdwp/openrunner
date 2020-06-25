//
// Created by shdwp on 5/22/2020.
//

#include "GameBoardView.h"
#include <util/Debug.h>
#include <util/Geom.h>

GameBoardView::GameBoardView(shared_ptr<Model> model): Entity::Entity(model)
{
}

GameBoardView::GameBoardView(): Entity::Entity() { }

void GameBoardView::addModelSlots() {
    for (auto &zone : *model_->zones) {
        auto box = zone.box;
        auto norm_box = glm::vec4(
        );

        auto a = glm::vec3(zone.box.x, 0.04f, zone.box.y);
        auto b = glm::vec3(zone.box.z, 0.04f, zone.box.w);

        auto pos = ((b - a) * 0.5f) + a;
        this->addSlot(zone.identifier, pos, ascendingZBox(zone.box));
    }
}

void GameBoardView::addSlot(const string& slotid, glm::vec3 pos, glm::vec4 bbox) {
    auto map = *slot_positions_;
    (*slot_positions_)[slotid] = pos;
    (*slot_bounding_boxes_)[slotid] = bbox;

    auto intrl = make_shared<SlotInteractable>(slotid, bbox);
    (*slot_interactables_)[slotid] = intrl;

    UILayer::layerFor(this)->registerInteractable(intrl);
}

bool GameBoardView::hasSlot(const string &slotid) const {
    return slot_positions_->find(slotid) != slot_positions_->end();
}

void GameBoardView::removeSlotView(const string& slotid, int idx) {
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

    for (auto &tup : *slot_interactables_) {
        tup.second->transform = transform;
    }

    /*
    for (auto &vec : *slot_bounding_boxes_) {
        auto zone = vec.second;

        auto a = glm::vec3(zone.x, 0, zone.y);
        auto b = glm::vec3(zone.z, 0, zone.w);
        auto mat = glm::translate(transform, ((b - a) * 0.5f) + a);
        mat = glm::translate(mat, glm::vec3(0.f, 0.f, 0.f));
        mat = glm::rotate(mat, (float)M_PI_2, glm::vec3(0.f, 1.f, 0.f));

        Debug::Shared->drawText(mat, vec.first);
    }
     */
}

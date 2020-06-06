//
// Created by shdwp on 6/5/2020.
//

#ifndef OPENRUNNER_SLOTINTERACTABLE_H
#define OPENRUNNER_SLOTINTERACTABLE_H


#include <ui/UILayer.h>

class SlotInteractable: public UIInteractable {
public:
    string slotid;
    glm::mat4 transform = glm::identity<glm::mat4>();
    glm::vec4 bbox;

    SlotInteractable(const string &slotid, glm::vec4 bbox): slotid(slotid), bbox(bbox) {}

    std::tuple<glm::vec4, glm::vec4> interactableArea() override {
        auto a = transform * glm::vec4(bbox.x, 0.f, bbox.y, 1.f);
        auto b = transform * glm::vec4(bbox.z, 0.f, bbox.w, 1.f);

        return std::tuple<glm::vec4, glm::vec4>(a, b);
    }
};


#endif //OPENRUNNER_SLOTINTERACTABLE_H

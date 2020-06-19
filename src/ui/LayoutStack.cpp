//
// Created by shdwp on 6/19/20.
//

#include "ui/LayoutStack.h"

void LayoutStack::update() {
    Entity::update();

    auto space_left = 1.f;

    for (auto i = begin(*children_); i != end(*children_); i++) {
        (*i)->scale = glm::vec3(0.f);
        if (auto child = dynamic_pointer_cast<ILayout>(*i)) {
            switch (orientation) {
                case LayoutStackOrientation_Horizontal:
                    if (child->layoutWidth > 0.f) {
                        space_left -= child->layoutWidth;
                        child->scale = glm::vec3(child->layoutWidth, 1.f, 1.f);
                    }

                    break;
                case LayoutStackOrientation_Vertical:
                    if (child->layoutHeight > 0.f) {
                        space_left -= child->layoutHeight;
                        child->scale = glm::vec3(1.f, child->layoutHeight, 1.f);
                    }
                    break;
            }
        }
    }

    auto other_child_scale = space_left / children_->size();
    auto offset = 0.f;

    for (auto &child : *children_) {
        switch (orientation) {
            case LayoutStackOrientation_Horizontal:
                if (child->scale.x == 0.f) {
                    child->scale = glm::vec3(other_child_scale, 1.f, 1.f);
                }

                child->position = glm::vec3(offset + child->scale.x / 2.f, 1.f, 1.f);
                offset+= child->scale.x;
                break;
            case LayoutStackOrientation_Vertical:
                if (child->scale.x == 0.f) {
                    child->scale = glm::vec3(1.f, other_child_scale, 1.f);
                }

                child->position = glm::vec3(1.f, offset + child->scale.y / 2.f, 1.f);
                offset+= child->scale.y;
                break;
        }
    }
}

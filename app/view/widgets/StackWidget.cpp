//
// Created by shdwp on 5/21/2020.
//

#include "StackWidget.h"

void StackWidget::update() {
    auto amount = children_->size();
    float scale = 0.1f;
    float space = bounding_box.z - bounding_box.x;
    float padding = 1.4f;

    float offset = amount * scale * padding <= space ? scale * padding : (space / amount);
    float initial_pos = 0.f;

    switch (alignment) {
        case StackWidgetAlignment_Max:
            offset *= -1.f;
            initial_pos = bounding_box.z;
            break;
        case StackWidgetAlignment_Min:
            initial_pos = bounding_box.x;
            break;
    }

    for (auto i = 0; i < amount; i++) {
        auto &child = (*children_)[i];
        auto pos = child->position;

        switch (orientation) {
            case StackWidgetOrientation_Horizontal:
                pos = glm::vec3(initial_pos + offset * i, 0, 0);
                break;
            case StackWidgetOrientation_Vertical:
                pos = glm::vec3(0, 0, initial_pos + offset * i);
                break;
        }

        child->position = pos;
        child->scale = glm::vec3(scale, 0.01, 0.1);
    }
}

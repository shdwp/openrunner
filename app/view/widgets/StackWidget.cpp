//
// Created by shdwp on 5/21/2020.
//

#include "StackWidget.h"

void StackWidget::update() {
    auto amount = children_->size();
    if (amount == 0) {
        return;
    }

    float scale = (*children_)[0]->scale.x;
    float padding = 1.4f;
    float space;
    float initial_pos;
    float offline_pos;

    switch (orientation) {
        case StackWidgetOrientation_Horizontal:
            space = bounding_box.z - bounding_box.x;
            offline_pos = bounding_box.y + (bounding_box.w - bounding_box.y) / 2.f;
            break;
        case StackWidgetOrientation_Vertical:
            space = bounding_box.w - bounding_box.y;
            offline_pos = bounding_box.x + (bounding_box.z - bounding_box.x) / 2.f;
            break;
    }

    float offset = amount * scale * padding <= space ? scale * padding : (space / amount);

    switch (alignment) {
        case StackWidgetAlignment_Max:
            initial_pos = bounding_box.x - (scale * padding) / 2.f;
            break;
        case StackWidgetAlignment_Min:
            offset *= -1.f;
            initial_pos = bounding_box.z + (scale * padding) / 2.f;
            break;
    }

    for (auto i = 0; i < amount; i++) {
        auto &child = (*children_)[i];
        auto pos = child->position;

        switch (orientation) {
            case StackWidgetOrientation_Horizontal:
                pos = glm::vec3(initial_pos + offset * i, 0, offline_pos);
                break;
            case StackWidgetOrientation_Vertical:
                pos = glm::vec3(offline_pos, 0, initial_pos + offset * i);
                break;
        }

        child->position = pos;
    }
}

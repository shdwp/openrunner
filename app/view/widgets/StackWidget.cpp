//
// Created by shdwp on 5/21/2020.
//

#include "StackWidget.h"

void StackWidget::update() {
    auto scaled_bbox = glm::vec4(
            bounding_box.x,
            bounding_box.y,
            bounding_box.z,
            bounding_box.w
            );

    auto amount = children_->size();
    if (amount == 0) {
        return;
    }

    float scale = (*children_)[0]->scale.x;
    float space;
    float initial_pos;
    float offline_pos;

    switch (orientation) {
        case StackWidgetOrientation_Horizontal:
            space = scaled_bbox.z - scaled_bbox.x;
            offline_pos = scaled_bbox.y + (scaled_bbox.w - scaled_bbox.y) / 2.f;
            break;
        case StackWidgetOrientation_Vertical:
            space = scaled_bbox.w - scaled_bbox.y;
            offline_pos = scaled_bbox.x + (scaled_bbox.z - scaled_bbox.x) / 2.f;
            break;
    }

    float offset = amount * scale * child_padding <= space ? scale * child_padding : (space / amount);

    switch (alignment) {
        case StackWidgetAlignment_Max:
            switch (orientation) {
                case StackWidgetOrientation_Horizontal:
                    initial_pos = scaled_bbox.x - (scale * child_padding) / 2.f;
                    break;
                case StackWidgetOrientation_Vertical:
                    initial_pos = scaled_bbox.y + (scale * child_padding) / 2.f;
                    break;
            }
            break;
        case StackWidgetAlignment_Min:
            offset *= -1.f;
            switch (orientation) {
                case StackWidgetOrientation_Horizontal:
                    initial_pos = scaled_bbox.z + (scale * child_padding) / 2.f;
                    break;
                case StackWidgetOrientation_Vertical:
                    initial_pos = scaled_bbox.w - (scale * child_padding) / 2.f;
                    break;
            }
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
        child->rotation = glm::rotate(child->rotation, glm::vec3(0.f, child_rotation, 0.f));
    }
}

void StackWidget::luaRegister(luabridge::Namespace ns) {
    struct helper {
        static int getOrientation(StackWidget const* widget) { return widget->orientation; }
        static int getAlignment(StackWidget const* widget) { return widget->alignment; }
        static void setOrientation(StackWidget *widget, int orientation) { widget->orientation = (stack_widget_orientation_t)orientation; }
        static void setAlignment(StackWidget *widget, int alignment) { widget->alignment = (stack_widget_alignment_t)alignment; }

        static float getPadding(StackWidget const* widget) { return widget->child_padding; }
        static float getRotation(StackWidget const* widget) { return widget->child_rotation; }
        static void setPadding(StackWidget *widget, float padding) { widget->child_padding = padding; }
        static void setRotation(StackWidget *widget, float rot) { widget->child_rotation = rot; }
    };

    ns
            .beginClass<StackWidget>("StackWidget")
            .addProperty("orientation", &helper::getOrientation, &helper::setOrientation)
            .addProperty("alignment", &helper::getAlignment, &helper::setAlignment)
            .addProperty("child_padding", &helper::getPadding, &helper::setPadding)
            .addProperty("child_rotation", &helper::getRotation, &helper::setRotation)
            .endClass();
}

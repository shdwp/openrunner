//
// Created by shdwp on 6/1/2020.
//

#include <util/Debug.h>
#include <ui/UILayer.h>
#include "ActionWidget.h"

ActionWidget::ActionWidget(): Entity() {
}

void ActionWidget::draw(glm::mat4 transform) {
    Entity::draw(transform);

    Debug::Shared->drawText(transform, text);
}

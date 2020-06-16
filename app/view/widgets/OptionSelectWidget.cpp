//
// Created by shdwp on 6/16/20.
//

#include "OptionSelectWidget.h"

void OptionSelectWidget::update() {
    Entity::update();
}

void OptionSelectWidget::draw(glm::mat4 transform) {
    Entity::draw(transform);

    for (auto &child : *options_) {
    }
}

void OptionSelectWidget::setOptions(vector<string> options) {
    for (auto &line in options) {
        
    }
}

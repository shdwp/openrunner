//
// Created by shdwp on 6/16/20.
//

#include "OptionSelectWidget.h"

void OptionSelectWidget::setOptions(std::map<string, string> options) {
    this->removeAllChildren();

    for (auto &intr : *interactables_) {
        UILayer::layerFor(this)->unregisterInteractable(intr);
    }

    for (auto i = begin(options); i != end(options); i++) {
        auto index = distance(begin(options), i);
        auto vertical_offset = 40.f;

        auto label = Label(font_);
        label.setText(i->second);
        label.position = glm::vec3(-250.f, 50.f + index * vertical_offset, 0.f);
        this->addChild(move(label));

        auto interactable = make_shared<OptionInteractable>();
        interactable->index = distance(begin(options), i);
        interactable->option = i->first;
        interactable->a = glm::vec4(-250.f, 50.f + index * vertical_offset, 0.f, 1.f);
        interactable->b = glm::vec4(0.f, 50.f + ((float)index + 1) * vertical_offset, 0.f, 1.f);

        interactables_->emplace_back(interactable);
        UILayer::layerFor(this)->registerInteractable(interactable);
    }
}

void OptionSelectWidget::draw(glm::mat4 transform) {
    Entity::draw(transform);

    for (auto &intr : *interactables_) {
        intr->transform = transform;
    }
}

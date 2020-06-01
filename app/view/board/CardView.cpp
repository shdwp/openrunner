//
// Created by shdwp on 5/22/2020.
//

#include <util/Debug.h>
#include "CardView.h"

shared_ptr<Model> CardView::SharedModel = nullptr;

CardView::CardView(shared_ptr<Card> card, const shared_ptr<Model>& model): Entity::Entity(model) {
    card_ = card;
    scale = glm::vec3(0.1f, 0.01f, 0.1f);
}

CardView CardView::ForCard(shared_ptr<Card> card) {
    return CardView(card, SharedModel);
}

void CardView::update() {
    Entity::update();

    this->rotation = glm::rotate(this->rotation, glm::vec3(this->card_->faceup ? M_PI : 0, 0, 0));
}

void CardView::draw(glm::mat4 transform) {
    Entity::draw(transform);

    if (card_ != nullptr) {
        Debug::Shared->drawText(glm::scale(transform, glm::vec3(10, 100, 10)), format("{}", card_->uid));
    }
}

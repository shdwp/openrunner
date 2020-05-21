//
// Created by shdwp on 5/22/2020.
//

#include "CardView.h"

shared_ptr<Model> CardView::SharedModel = nullptr;

CardView::CardView(shared_ptr<Card> card, shared_ptr<Model> model): Entity::Entity(model) {
    card_ = card;
}

CardView CardView::ForCard(shared_ptr<Card> card) {
    return CardView(card, SharedModel);
}

void CardView::update() {
    Entity::update();

    this->rotation = glm::rotate(this->rotation, glm::vec3(this->card_->faceup ? M_PI : 0, 0, 0));
}

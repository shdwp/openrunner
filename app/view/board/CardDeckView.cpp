//
// Created by shdwp on 6/4/2020.
//

#include <util/Debug.h>
#include "CardDeckView.h"
#include "CardView.h"

CardDeckView::CardDeckView(shared_ptr<CardDeck> deck, const shared_ptr<Model> &model):
        CardView(CardView::SharedModel),
        deck_(deck)
{
    scale = glm::vec3(0.1f, 0.1f, 0.1f);
}

CardDeckView CardDeckView::For(shared_ptr<CardDeck> deck) {
    return CardDeckView(deck, CardView::SharedModel);
}

void CardDeckView::update() {
    CardView::update();

    scale.y = 0.01f * deck_->size();
    card_ = deck_->top();
}

void CardDeckView::draw(glm::mat4 transform) {
    CardView::draw(transform);

    if (deck_ != nullptr) {
        Debug::Shared->drawText(glm::scale(transform, glm::vec3(10, 100, 10)), format("d{}", deck_->size()));
    }
}


//
// Created by shdwp on 6/4/2020.
//

#include <util/Debug.h>
#include "DeckView.h"
#include "CardView.h"

DeckView::DeckView(luabridge::RefCountedPtr<Deck> deck, const shared_ptr<Model> &model):
        CardView(CardView::SharedModel),
        deck_(deck)
{
    scale = glm::vec3(0.2f, 0.1f, 0.2f);
}

DeckView DeckView::For(luabridge::RefCountedPtr<Deck> deck) {
    return DeckView(deck, CardView::SharedModel);
}

void DeckView::update() {
    CardView::update();

    scale.y = 0.005f * deck_->size();
    card = deck_->top();
}

void DeckView::draw(glm::mat4 transform) {
    CardView::draw(transform);

    if (deck_.get() != nullptr) {
        auto mat = transform;
        mat = glm::translate(mat, glm::vec3(0.f, 2.f, 0.f));
        mat = glm::scale(mat, glm::vec3(10.f, 100.f, 10.f));

        Debug::Shared->drawText(mat, format("d{}", deck_->size()));
    }
}


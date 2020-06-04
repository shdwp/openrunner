//
// Created by shdwp on 6/4/2020.
//

#include <util/Debug.h>
#include "CardDeckView.h"
#include "CardView.h"

CardDeckView::CardDeckView(shared_ptr<CardDeck> deck, const shared_ptr<Model> &model):
        SlotView(model),
        deck_(deck)
{
    scale = glm::vec3(0.1f, 0.1f, 0.1f);
}

CardDeckView CardDeckView::ForDeck(shared_ptr<CardDeck> deck) {
    return CardDeckView(deck, CardView::SharedModel);
}

void CardDeckView::update() {
    Entity::update();

    scale.y = 0.01f * deck_->size();
}

void CardDeckView::draw(glm::mat4 transform) {
    Entity::draw(transform);
    uiTransform_ = transform;

    if (deck_ != nullptr) {
        Debug::Shared->drawText(glm::scale(transform, glm::vec3(10, 100, 10)), format("d{}", deck_->size()));
    }
}

glm::vec4 CardDeckView::getArea(const Camera &cam) {
    auto a = cam.projection * cam.lookAt() * uiTransform_ * glm::vec4(-0.65f, 0.f, -1.f, 1.f);
    auto b = cam.projection * cam.lookAt() * uiTransform_ * glm::vec4(0.65f, 0.f, 1.f, 1.f);

    return glm::vec4(
            a.x < b.x ? a.x : b.x,
            a.y < b.y ? a.y : b.y,
            b.x > a.x ? b.x : a.x,
            b.y > a.y ? b.y : a.y
    );
}

void CardDeckView::clicked(glm::vec3 pos) {

}

//
// Created by shdwp on 5/22/2020.
//

#include <util/Debug.h>
#include "CardView.h"

shared_ptr<Model> CardView::SharedModel = nullptr;

CardView::CardView(shared_ptr<Card> card, const shared_ptr<Model>& model): SlotView::SlotView(model) {
    card_ = card;
    scale = glm::vec3(0.1f, 0.01f, 0.1f);
}

CardView CardView::For(shared_ptr<Card> card) {
    return CardView(card, SharedModel);
}

void CardView::update() {
    Entity::update();

    if (card_ != nullptr) {
        this->rotation = glm::rotate(this->rotation, this->card_->faceup ? (float) M_PI : 0.f, glm::vec3(1.f, 0.f, 0.f));
    }
}

void CardView::draw(glm::mat4 transform) {
    Entity::draw(transform);
    uiTransform_ = transform;

    if (card_ != nullptr) {
        Debug::Shared->drawText(glm::scale(transform, glm::vec3(10, 100, 10)), format("{}", card_->uid));
    }
}

glm::vec4 CardView::getArea(const Camera &cam) {
    auto a = cam.projection * cam.lookAt() * uiTransform_ * glm::vec4(-0.65f, 0.f, -1.f, 1.f);
    auto b = cam.projection * cam.lookAt() * uiTransform_ * glm::vec4(0.65f, 0.f, 1.f, 1.f);

    return glm::vec4(
            a.x < b.x ? a.x : b.x,
            a.y < b.y ? a.y : b.y,
            b.x > a.x ? b.x : a.x,
            b.y > a.y ? b.y : a.y
    );
}

void CardView::clicked(glm::vec3 pos) {

}

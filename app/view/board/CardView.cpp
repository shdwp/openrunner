//
// Created by shdwp on 5/22/2020.
//

#include <util/Debug.h>
#include "CardView.h"

shared_ptr<Model> CardView::SharedModel = nullptr;
shared_ptr<CardMaterial> CardView::SharedMaterial = nullptr;

CardView::CardView(shared_ptr<Card> card, const shared_ptr<Model>& model):
        SlotView::SlotView(model),
        card(card)
{
    scale = glm::vec3(0.1f, 0.01f, 0.1f);
}

CardView CardView::For(shared_ptr<Card> _card) {
    return CardView(_card, SharedModel);
}

void CardView::update() {
    Entity::update();

    if (card != nullptr) {
        rotation = glm::rotate(rotation, (card->faceup || force_faceup) ? (float) M_PI : 0.f, glm::vec3(1.f, 0.f, 0.f));
    }
}

void CardView::draw(glm::mat4 transform) {
    uiTransform_ = transform;

    if (card != nullptr) {
        SharedMaterial->setupFor(*card);
        Entity::draw(transform);

        Debug::Shared->drawText(glm::scale(transform, glm::vec3(10, 100, 10)), format("{}", card->uid));
    }
}

std::tuple<glm::vec4, glm::vec4, int> CardView::interactableArea() {
    auto a = uiTransform_ * glm::vec4(-0.65f, 0.f, -1.f, 1.f);
    auto b = uiTransform_ * glm::vec4(0.65f, 0.f, 1.f, 1.f);
    return std::tuple(a, b, ui_z_index);
}


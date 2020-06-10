//
// Created by shdwp on 6/7/2020.
//

#include <util/Debug.h>
#include "CardSelectWidget.h"
#include "../board/CardView.h"

void CardSelectWidget::setDeck(Deck *deck, size_t limit) {
    for (auto i = begin(*deck->cards); i != begin(*deck->cards) + limit; i++) {
        auto view = addChild(CardView::For(*i));
        UILayer::registerSceneEntity(view);
    }
}

void CardSelectWidget::removeCard(Card *ptr) {
    for (auto &child : *children_) {
        if (auto view = dynamic_pointer_cast<CardView>(child)) {
            if (view->getUnownedCardPtr() == ptr) {
                removeChild(child);
                break;
            }
        }
    }
}

void CardSelectWidget::update() {
    Entity::update();

    if (!hidden) {
        auto scale_fac = 1.f / scale.x;
        auto start_point = (glm::vec2(-320.f, 200.f) + offset) * scale_fac;
        auto padding = glm::vec2(80.f, 140.f) * scale_fac;
        auto rows = 8;

        for (auto i = 0; i < children_->size(); i++) {
            auto col = (int) floorf((float) i / rows);
            auto row = i - col * rows;

            if (auto view = dynamic_pointer_cast<CardView>(children_->at(i))) {
                view->force_faceup = true;
                view->position = glm::vec3(start_point.x + row * padding.x, 0.f, start_point.y - col * padding.y);
            }
        }
    }
}


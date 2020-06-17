//
// Created by shdwp on 6/7/2020.
//

#include <util/Debug.h>
#include "ZoomCardView.h"

void ZoomCardView::setCard(shared_ptr<Card> card_ptr, const string &str) {
    card = card_ptr;
    text = str;
}

void ZoomCardView::update() {
    rotation = glm::rotate(rotation, glm::vec3((float)M_PI_2 + M_PI, 0.f, 0.f));
}

void ZoomCardView::draw(glm::mat4 transform) {
    CardView::draw(transform);

    auto mat = transform;
    mat = glm::translate(mat, glm::vec3(-1.4f, 0.f, 0.5f));
    mat = glm::scale(mat, glm::vec3(2.f));
    mat = glm::rotate(mat, (float)M_PI, glm::vec3(1.f, 0.f, 0.f));
    Debug::Shared->drawText(mat, text, DebugDraw_Red | DebugDraw_Blue | DebugDraw_Green);
}

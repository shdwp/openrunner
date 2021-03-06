//
// Created by shdwp on 6/7/2020.
//

#include <util/Debug.h>
#include "ZoomCardView.h"

void ZoomCardView::setCard(luabridge::RefCountedPtr<Card> card_ptr, const string &str) {
    card = card_ptr;
    description = str;
}

void ZoomCardView::update() {
    rotation = glm::rotate(rotation, glm::vec3((float)M_PI_2 + M_PI, 0.f, 0.f));
}

void ZoomCardView::draw(glm::mat4 transform) {
    CardView::draw(transform);

    auto mat = transform;
    mat = glm::translate(mat, glm::vec3(-0.7f, 0.f, 0.2f));
    mat = glm::rotate(mat, (float)M_PI, glm::vec3(1.f, 0.f, 0.f));

    if (*this->card != nullptr) {
        auto text = format("uid: {}\nslotid: {}\nfaceup: {}\n{}", this->card->uid, this->card->slotid, this->card->faceup, this->description);
        Debug::Shared->drawText(mat, text, DebugDraw_Red | DebugDraw_Green | DebugDraw_Blue);
    }
}

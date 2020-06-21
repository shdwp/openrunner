//
// Created by shdwp on 5/22/2020.
//

#include <util/Debug.h>
#include "CardView.h"

shared_ptr<Model> CardView::SharedModel = nullptr;
shared_ptr<CardMaterial> CardView::SharedMaterial = nullptr;

CardView::CardView(luabridge::RefCountedPtr<Card> card, const shared_ptr<Model>& model):
        SlotView::SlotView(model),
        card(card)
{
    scale = glm::vec3(0.1f, 0.01f, 0.1f);
}

CardView CardView::For(luabridge::RefCountedPtr<Card> _card) {
    return CardView(_card, SharedModel);
}

void CardView::update() {
    Entity::update();

    if (card.get() != nullptr) {
        rotation = glm::rotate(rotation, (card->faceup || force_faceup) ? (float) M_PI : 0.f, glm::vec3(1.f, 0.f, 0.f));
    }
}

void CardView::draw(glm::mat4 transform) {
    uiTransform_ = transform;

    if (card.get() != nullptr) {
        glEnable(GL_STENCIL_TEST);

        glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
        glStencilFunc(GL_ALWAYS, 1, 0xff);
        glStencilMask(0xff);
        SharedMaterial->setupFor(*card.get());
        Entity::draw(transform);

        if (card->highlighted) {
            glDisable(GL_DEPTH_TEST);
            glStencilFunc(GL_NOTEQUAL, 1, 0xff);
            glStencilMask(0x00);
            SharedMaterial->setupForHighlight();
            Entity::draw(glm::scale(transform, glm::vec3(1.3f)));
            glEnable(GL_DEPTH_TEST);

            glDisable(GL_STENCIL_TEST);
        }

        // Debug::Shared->drawText(glm::scale(transform, glm::vec3(10, 100, 10)), format("{}", card->uid));
    }
}

std::tuple<glm::vec4, glm::vec4, int> CardView::interactableArea() {
    auto a = uiTransform_ * glm::vec4(-0.65f, 0.f, -1.f, 1.f);
    auto b = uiTransform_ * glm::vec4(0.65f, 0.f, 1.f, 1.f);
    return std::tuple(a, b, ui_z_index);
}


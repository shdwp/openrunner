//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDVIEW_H
#define OPENRUNNER_CARDVIEW_H


#include <ui/UILayer.h>
#include "SlotView.h"
#include "../../model/card/Card.h"
#include "../materials/CardMaterial.h"

class CardView: public SlotView, public UIInteractable {
protected:
    glm::mat4 uiTransform_ = glm::mat4(0.f);

public:
    shared_ptr<Card> card;
    bool force_faceup = false;

    using SlotView::SlotView;

    CardView(shared_ptr<Card> card, const shared_ptr<Model>& model);

    static shared_ptr<Model> SharedModel;
    static shared_ptr<CardMaterial> SharedMaterial;
    static CardView For(shared_ptr<Card> card);

    [[nodiscard]] Card *getUnownedCardPtr() const { return card.get(); }

    string debugDescription() override { return format("{} CardView {}, {}", Entity::debugDescription(), card->uid, card->faceup); };

    void *itemPointer() override { return card.get(); }

    template <class T>
    void setItem(shared_ptr<T> item) {
        card = item;
    }

    std::tuple<glm::vec4, glm::vec4> interactableArea() override;

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDVIEW_H

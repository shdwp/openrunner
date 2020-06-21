//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDVIEW_H
#define OPENRUNNER_CARDVIEW_H


#include <ui/UILayer.h>
#include <LuaBridge/RefCountedPtr.h>
#include "SlotView.h"
#include "../../model/card/Card.h"
#include "../materials/CardMaterial.h"

class CardView: public SlotView, public UIInteractable {
protected:
    glm::mat4 uiTransform_ = glm::mat4(0.f);

public:
    luabridge::RefCountedPtr<Card> card;
    bool force_faceup = false;
    int ui_z_index = 1;

    using SlotView::SlotView;

    CardView(luabridge::RefCountedPtr<Card> card, const shared_ptr<Model>& model);

    static shared_ptr<Model> SharedModel;
    static shared_ptr<CardMaterial> SharedMaterial;
    static CardView For(luabridge::RefCountedPtr<Card> card);

    [[nodiscard]] Card *getUnownedCardPtr() const { return card.get(); }

    string debugDescription() override { return format("{} CardView {}, {}", Entity::debugDescription(), card->uid, card->faceup); };

    void *itemPointer() override { return card.get(); }

    template <class T>
    void setItem(shared_ptr<T> item) {
        card = item;
    }

    std::tuple<glm::vec4, glm::vec4, int> interactableArea() override;

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDVIEW_H

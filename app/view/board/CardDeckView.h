//
// Created by shdwp on 6/4/2020.
//

#ifndef OPENRUNNER_CARDDECKVIEW_H
#define OPENRUNNER_CARDDECKVIEW_H

#include <ui/UILayer.h>
#include "SlotView.h"
#include "../../model/card/CardDeck.h"

class CardDeckView: public SlotView, public UIInteractable {
private:
    shared_ptr<CardDeck> deck_;
    glm::mat4 uiTransform_;

public:
    using SlotView::SlotView;

    explicit CardDeckView(shared_ptr<CardDeck> deck, const shared_ptr<Model>& model);

    static CardDeckView ForDeck(shared_ptr<CardDeck> deck);

    string debugDescription() override { return format("{} CardDeckView {}, {}", Entity::debugDescription(), deck_->topCard()->uid, deck_->size()); };

    glm::vec4 getArea(const Camera &cam) override;

    void clicked(glm::vec3 pos) override;

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDDECKVIEW_H

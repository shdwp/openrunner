//
// Created by shdwp on 6/4/2020.
//

#ifndef OPENRUNNER_CARDDECKVIEW_H
#define OPENRUNNER_CARDDECKVIEW_H

#include <ui/UILayer.h>
#include "../../model/card/CardDeck.h"
#include "CardView.h"

class CardDeckView: public CardView {
private:
    shared_ptr<CardDeck> deck_;
    glm::mat4 uiTransform_;

public:
    using CardView::CardView;

    explicit CardDeckView(shared_ptr<CardDeck> deck, const shared_ptr<Model>& model);

    static CardDeckView For(shared_ptr<CardDeck> deck);

    string debugDescription() override { return format("{} CardDeckView {}, {}", Entity::debugDescription(), deck_->top()->uid, deck_->size()); };

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDDECKVIEW_H

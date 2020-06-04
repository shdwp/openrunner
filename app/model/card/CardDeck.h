//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_CARDDECK_H
#define OPENRUNNER_CARDDECK_H


#include <engine/Entity.h>
#include "Card.h"

class CardDeck: public Item {
private:
    shared_ptr<Entity> entity_;
    unique_ptr<vector<shared_ptr<Card>>> cards_;
public:
    [[nodiscard]] shared_ptr<Card> topCard() const;

    size_t size() { return cards_->size(); }

};


#endif //OPENRUNNER_CARDDECK_H

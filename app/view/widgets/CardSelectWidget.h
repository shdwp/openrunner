//
// Created by shdwp on 6/7/2020.
//

#ifndef OPENRUNNER_CARDSELECTWIDGET_H
#define OPENRUNNER_CARDSELECTWIDGET_H


#include <engine/Entity.h>
#include "../../model/card/Card.h"
#include "../../model/card/Deck.h"

class CardSelectWidget: public Entity {
private:

public:
    using Entity::Entity;

    glm::vec2 offset = glm::vec2(0.f);

    string debugDescription() override { return format("{} CardSelectWidget", Entity::debugDescription()); }

    void setDeck(Deck *deck, size_t limit);

    void removeCard(Card *card);

    void update() override;
};


#endif //OPENRUNNER_CARDSELECTWIDGET_H

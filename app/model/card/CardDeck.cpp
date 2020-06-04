//
// Created by shdwp on 5/21/2020.
//

#include "CardDeck.h"

shared_ptr<Card> CardDeck::topCard() const {
    return (*cards_)[0];
}

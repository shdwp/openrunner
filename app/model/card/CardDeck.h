//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_CARDDECK_H
#define OPENRUNNER_CARDDECK_H


#include <engine/Entity.h>
#include "Card.h"

class CardDeck: public Item {
private:
    unique_ptr<vector<shared_ptr<Card>>> cards_ = nullptr;

    static void Copy(CardDeck *a, const CardDeck &b) {
        a->cards_ = make_unique<vector<shared_ptr<Card>>>(*b.cards_);
    }

public:
    CardDeck(): cards_(make_unique<vector<shared_ptr<Card>>>()) {}

    CardDeck(const CardDeck &b) {
        Copy(this, b);
    }

    CardDeck& operator=(const CardDeck &b) {
        Copy(this, b);
        return *this;
    }

    void insert(const Card &card, int idx) {
        if (idx == -1) {
            idx = cards_->size();
        }

        cards_->insert(cards_->begin() + idx, make_shared<Card>(card));
    }

    void append(const Card &card) {
        insert(card, -1);
    }

    void remove(int idx) {
        cards_->erase(cards_->begin() + idx);
    }

    shared_ptr<Card> takeTop() {
        if (cards_->empty()) {
            return nullptr;
        }

        auto ptr = cards_->back();
        cards_->pop_back();
        return ptr;
    }

    shared_ptr<Card> takeBottom() {
        if (cards_->empty()) {
            return nullptr;
        }

        auto ptr = cards_->front();
        cards_->erase(cards_->begin());
        return ptr;
    }

    [[nodiscard]] shared_ptr<Card> top() const {
        if (cards_->empty()) {
            return nullptr;
        } else {
            return cards_->front();
        }
    }

    [[nodiscard]] size_t size() const { return cards_->size(); }
};


#endif //OPENRUNNER_CARDDECK_H

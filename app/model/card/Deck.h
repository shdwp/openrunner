//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_DECK_H
#define OPENRUNNER_DECK_H


#include <engine/Entity.h>
#include "Card.h"

class Deck: public Item {
private:
    unique_ptr<vector<shared_ptr<Card>>> cards_ = nullptr;

    static void Copy(Deck *a, const Deck &b) {
        a->cards_ = make_unique<vector<shared_ptr<Card>>>(*b.cards_);
    }

public:
    Deck(): cards_(make_unique<vector<shared_ptr<Card>>>()) {}

    Deck(const Deck &b) {
        Copy(this, b);
    }

    Deck& operator=(const Deck &b) {
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

    void shuffle() {
        std::random_shuffle(begin(*cards_), end(*cards_));
    }

    Card takeTop() {
        if (cards_->empty()) {
            return Card(0, nullptr);
        }

        auto ptr = cards_->back();
        cards_->pop_back();

        auto card = *ptr;
        return card;
    }

    Card takeBottom() {
        if (cards_->empty()) {
            return Card(0, nullptr);
        }

        auto ptr = cards_->front();
        cards_->erase(cards_->begin());
        return *ptr;
    }

    [[nodiscard]] Card *topUnowned() const {
        if (cards_->empty()) {
            return nullptr;
        } else {
            return cards_->front().get();
        }
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


#endif //OPENRUNNER_DECK_H

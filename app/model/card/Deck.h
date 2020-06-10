//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_DECK_H
#define OPENRUNNER_DECK_H


#include <engine/Entity.h>
#include "Card.h"

class Deck: public Item {
private:
    static void Copy(Deck *a, const Deck &b) {
        a->cards = make_unique<vector<shared_ptr<Card>>>(*b.cards);
    }

public:
    unique_ptr<vector<shared_ptr<Card>>> cards = nullptr;

    Deck(): cards(make_unique<vector<shared_ptr<Card>>>()) {}

    Deck(const Deck &b) {
        Copy(this, b);
    }

    Deck& operator=(const Deck &b) {
        Copy(this, b);
        return *this;
    }

    void insert(const Card &card, int idx) {
        if (idx == -1) {
            idx = cards->size();
        }

        cards->insert(cards->begin() + idx, make_shared<Card>(card));
    }

    void append(const Card &card) {
        insert(card, -1);
    }

    void remove(int idx) {
        cards->erase(cards->begin() + idx);
    }

    void shuffle() {
        std::random_shuffle(begin(*cards), end(*cards));
    }

    Card takeTop() {
        if (cards->empty()) {
            return Card(0, nullptr);
        }

        auto ptr = cards->back();
        cards->pop_back();

        auto card = *ptr;
        return card;
    }

    Card takeBottom() {
        if (cards->empty()) {
            return Card(0, nullptr);
        }

        auto ptr = cards->front();
        cards->erase(cards->begin());
        return *ptr;
    }

    [[nodiscard]] Card *topUnowned() const {
        if (cards->empty()) {
            return nullptr;
        } else {
            return cards->front().get();
        }
    }

    [[nodiscard]] shared_ptr<Card> top() const {
        if (cards->empty()) {
            return nullptr;
        } else {
            return cards->front();
        }
    }

    [[nodiscard]] size_t size() const { return cards->size(); }
};


#endif //OPENRUNNER_DECK_H

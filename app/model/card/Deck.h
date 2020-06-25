//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_DECK_H
#define OPENRUNNER_DECK_H


#include <engine/Entity.h>
#include <LuaBridge/RefCountedPtr.h>
#include "Card.h"

class Deck: public Item {
private:
    static void Copy(Deck *a, const Deck &b) {
        a->cards = make_unique<vector<luabridge::RefCountedPtr<Card>>>(*b.cards);
    }

public:
    unique_ptr<vector<luabridge::RefCountedPtr<Card>>> cards = nullptr;

    Deck(): cards(make_unique<vector<luabridge::RefCountedPtr<Card>>>()) {}

    Deck(const Deck &b) {
        Copy(this, b);
    }

    Deck& operator=(const Deck &b) {
        Copy(this, b);
        return *this;
    }

    void insert(Card &card, int idx) {
        if (idx == -1) {
            idx = cards->size();
        }

        card.slotid = this->slotid;
        cards->insert(cards->begin() + idx, new Card(card));
    }

    void append(Card &card) {
        insert(card, -1);
    }

    void moveToTop(const Card &card) {
        auto val = card;

    }

    void remove(int idx) {
        cards->erase(cards->begin() + idx);
    }

    void erase(Card *card) {
        for (auto i = begin(*cards); i != end(*cards); i++) {
            if (card == i->get()) {
                *cards->erase(i);
                return;
            }
        }
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

        auto card = ptr.get();
        return *card;
    }

    Card takeBottom() {
        if (cards->empty()) {
            return Card(0, nullptr);
        }

        auto ptr = cards->front();
        cards->erase(cards->begin());
        return *ptr.get();
    }

    [[nodiscard]] Card *topUnowned() const {
        if (cards->empty()) {
            return nullptr;
        } else {
            return cards->front().get();
        }
    }

    [[nodiscard]] luabridge::RefCountedPtr<Card> top() const {
        if (cards->empty()) {
            return nullptr;
        } else {
            return cards->front();
        }
    }

    [[nodiscard]] luabridge::RefCountedPtr<Card> at(size_t idx) const {
        return cards->at(idx);
    }

    [[nodiscard]] size_t size() const { return cards->size(); }
};


#endif //OPENRUNNER_DECK_H

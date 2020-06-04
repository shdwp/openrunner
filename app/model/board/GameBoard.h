//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_GAMEBOARD_H
#define OPENRUNNER_GAMEBOARD_H

#include <engine/Entity.h>
#include <unordered_map>
#include <scripting/LuaHost.h>

#include "../card/Card.h"
#include "../card/CardDeck.h"
#include "../../view/board/GameBoardView.h"

class GameBoard {
private:
    unique_ptr<std::unordered_map<string, vector<shared_ptr<Card>>>> cards_;

    static void Copy(GameBoard *a, const GameBoard &b) {
        a->views = b.views;
        a->cards_ = make_unique<std::unordered_map<string, vector<shared_ptr<Card>>>>(*b.cards_);
    }

    [[nodiscard]] shared_ptr<GameBoardView> findViewFor(const string& slotid) const;

public:
    shared_ptr<vector<shared_ptr<GameBoardView>>> views;

    explicit GameBoard();

    GameBoard(const GameBoard& board) noexcept {
        Copy(this, board);
    }

    GameBoard& operator=(const GameBoard &b) noexcept {
        Copy(this, b);
        return *this;
    }

    void addView(GameBoardView &&view) {
        views->emplace_back(make_shared<GameBoardView>(move(view)));
    }

    void addView(const shared_ptr<GameBoardView>& view_ptr) {
        views->emplace_back(view_ptr);
    }

    template <class T, class V>
    T *insert(const string &slotid, const T &card, size_t idx = 0) {
        auto vec = &(*cards_)[slotid];
        auto ptr = make_shared<T>(card);
        vec->insert(vec->begin() + idx, ptr);

        if (auto view = findViewFor(slotid)) {
            auto stack_widget = view->getSlotView<StackWidget>(slotid);
            if (stack_widget == nullptr) {
                stack_widget = view->addSlotView(slotid, StackWidget());
            }

            auto card_view = stack_widget->addChild(V::ForCard(card));
            UILayer::registerSceneEntity(card_view);
        }

        return ptr.get();
    }

    void erase(const string &slotid, size_t idx = 0) {
        auto vec = &(*cards_)[slotid];
        vec->erase(vec->begin() + idx);
    }

    template <class T>
    T *emplace_back(const string &slotid, const T &card) {
        return this->insert(slotid, card, (*cards_)[slotid].size());
    }

    template <class T>
    T *replace(const string &slotid, const T &card, size_t idx = 0) {
        this->erase(slotid, idx);
        return this->insert(slotid, card, idx);
    }

    template <class T>
    shared_ptr<T> *get(const string &slotid, int idx = 0) {
        auto p = (*cards_)[slotid][idx];
        return dynamic_pointer_cast<T>(p);
    }

    static void luaRegister(luabridge::Namespace);
};


#endif //OPENRUNNER_GAMEBOARD_H

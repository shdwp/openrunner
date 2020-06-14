//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_GAMEBOARD_H
#define OPENRUNNER_GAMEBOARD_H

#include <engine/Entity.h>
#include <unordered_map>
#include <scripting/LuaHost.h>

#include "../card/Card.h"
#include "../card/Deck.h"
#include "../../view/board/GameBoardView.h"

class GameBoard {
private:
    // TODO: move to lua-shared ownership for cards
    unique_ptr<std::unordered_map<string, vector<shared_ptr<Item>>>> cards_;

    static void Copy(GameBoard *a, const GameBoard &b) {
        a->views = b.views;
        a->cards_ = make_unique<std::unordered_map<string, vector<shared_ptr<Item>>>>(*b.cards_);
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
    T *insert(const string &slotid, const T &card, int idx) {
        auto vec = &(*cards_)[slotid];
        auto ptr = make_shared<T>(card);

        if (idx == -1) {
            idx = vec->size();
        }

        vec->insert(vec->begin() + idx, ptr);

        if (auto view = findViewFor(slotid)) {
            auto stack_widget = view->getSlotView<StackWidget>(slotid);
            if (stack_widget == nullptr) {
                stack_widget = view->addSlotView(slotid, StackWidget());
            }

            auto card_view = stack_widget->addChild(V::For(ptr));
            card_view->slotid = slotid;
            UILayer::registerSceneEntity(card_view);
        }

        return ptr.get();
    }

    template <class T>
    int erase(const string &slotid, T* item) {
        auto vec = &(*cards_)[slotid];

        for (auto i = vec->begin(); i != vec->end(); i++) {
            if (i->get() == item) {
                if (auto view = findViewFor(slotid)) {
                    auto stack_widget = view->getSlotView<StackWidget>(slotid);
                    if (stack_widget != nullptr) {
                        stack_widget->removeChild([item](shared_ptr<Entity> ptr) {
                            if (auto view = dynamic_pointer_cast<SlotView>(ptr)) {
                                if (view->itemPointer() == item) {
                                    UILayer::unregisterSceneEntity(view);
                                    return true;
                                }
                            }

                            return false;
                        });
                    }
                }

                vec->erase(i);
                return distance(vec->begin(), i);
            }
        }

        return -1;
    }

    template <class T, class V>
    T *append(const string &slotid, const T &card) {
        return insert<T, V>(slotid, card, -1);
    }

    template <class T>
    T pop(const string &slotid, T *ptr) {
        auto card = *ptr;
        erase<T>(slotid, ptr);
        return card;
    }

    template <class O, class T, class V>
    T *replace(const string &slotid, O *from, const T &to) {
        auto idx = this->erase(slotid, from);
        if (idx != -1) {
            return this->insert<T, V>(slotid, to, idx);
        } else {
            return nullptr;
        }
    }

    template <class T>
    T *get(const string &slotid, int idx = 0) {
        auto vec = &(*cards_)[slotid];
        if (vec->size() > idx) {
            auto p = vec->at(idx);
            return dynamic_pointer_cast<T>(p).get();
        } else {
            return nullptr;
        }
    }

    size_t count(const string &slotid) {
        auto vec = &(*cards_)[slotid];
        return vec->size();
    }
};


#endif //OPENRUNNER_GAMEBOARD_H

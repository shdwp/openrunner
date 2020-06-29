//
// Created by shdwp on 5/21/2020.
//

#include "GameBoard.h"
#include "../../view/widgets/StackWidget.h"
#include "../../view/board/DeckView.h"

GameBoard::GameBoard():
        views(make_shared<vector<shared_ptr<GameBoardView>>>()),
        cards_(make_unique<std::unordered_map<string, vector<luabridge::RefCountedPtr<Item>>>>())
{
}

luabridge::RefCountedPtr<GameBoard> GameBoard::viewlessDeepcopy() const {
    auto board = new GameBoard();
    auto cards_copy = std::unordered_map<string, vector<luabridge::RefCountedPtr<Item>>>();

    for (auto pair : *cards_) {
        auto vec_copy = vector<luabridge::RefCountedPtr<Item>>();
        for (auto item : pair.second) {
            if (auto card = dynamic_cast<Card *>(item.get())) {
                vec_copy.emplace_back(luabridge::RefCountedPtr(new Card(*card)));
            } else if (auto deck = dynamic_cast<Deck *>(item.get())) {
                vec_copy.emplace_back(luabridge::RefCountedPtr(new Deck(*deck)));
            } else {
                FAIL("Unknown class");
            }
        }

        cards_copy[pair.first] = vec_copy;
    }

    board->cards_ = make_unique<std::unordered_map<string, vector<luabridge::RefCountedPtr<Item>>>>(cards_copy);
    return luabridge::RefCountedPtr<GameBoard>(board);
}

shared_ptr<GameBoardView> GameBoard::findViewFor(const string &slotid) const {
    for (auto &view : *views) {
        if (view->hasSlot(slotid)) {
            return view;
        }
    }

    return nullptr;
}


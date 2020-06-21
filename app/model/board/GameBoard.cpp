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

shared_ptr<GameBoardView> GameBoard::findViewFor(const string &slotid) const {
    for (auto &view : *views) {
        if (view->hasSlot(slotid)) {
            return view;
        }
    }

    return nullptr;
}


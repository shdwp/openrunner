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
    unique_ptr<std::unordered_map<string, shared_ptr<vector<shared_ptr<Card>>>>> stack_slots_;
    unique_ptr<std::unordered_map<string, shared_ptr<Card>>> single_slots_;

    static void Copy(GameBoard *a, const GameBoard &b) {
        a->view = b.view;
        a->stack_slots_ = make_unique<std::unordered_map<string, shared_ptr<vector<shared_ptr<Card>>>>>(*b.stack_slots_);
        a->single_slots_ = make_unique<std::unordered_map<string, shared_ptr<Card>>>(*b.single_slots_);
    }

public:
    shared_ptr<GameBoardView> view;

    explicit GameBoard(shared_ptr<GameBoardView> view);

    static void luaRegister(luabridge::Namespace);

    GameBoard(const GameBoard& board) noexcept {
        Copy(this, board);
    }

    GameBoard& operator=(const GameBoard &b) noexcept {
        Copy(this, b);
        return *this;
    }

    Card *assign(const string& slotid, const Card &card);
    Card *get(const string& slotid);
    void remove(const string& slotid);

    Card *push(const string& slotid, const Card &card);
    Card *find(const string& slotid, int idx);
    void pull(const string& slotid, int idx);
};


#endif //OPENRUNNER_GAMEBOARD_H

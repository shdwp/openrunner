//
// Created by shdwp on 5/21/2020.
//

#ifndef OPENRUNNER_GAMEBOARD_H
#define OPENRUNNER_GAMEBOARD_H

#include <engine/Entity.h>
#include <unordered_map>
#include "../card/Card.h"
#include "../card/CardDeck.h"
#include "../../view/board/GameBoardView.h"

class GameBoard {
private:
    unique_ptr<std::unordered_map<string, shared_ptr<vector<shared_ptr<Card>>>>> stack_slots_;
    unique_ptr<std::unordered_map<string, shared_ptr<Card>>> single_slots_;

public:
    shared_ptr<GameBoardView> view;

    explicit GameBoard(shared_ptr<GameBoardView> view);

    shared_ptr<Card> assign(string slotid, Card &&card);
    shared_ptr<Card> get(string slotid);
    void remove(string slotid);

    shared_ptr<Card> push(string slotid, Card &&card);
    shared_ptr<Card> find(string slotid, int idx);
    void pull(string slotid, int idx);
};


#endif //OPENRUNNER_GAMEBOARD_H

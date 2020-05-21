//
// Created by shdwp on 5/21/2020.
//

#include "GameBoard.h"
#include "../../view/widgets/StackWidget.h"

GameBoard::GameBoard(shared_ptr<GameBoardView> view) {
    this->view = view;
    stack_slots_ = make_unique<std::unordered_map<string, shared_ptr<vector<shared_ptr<Card>>>>>();
    single_slots_ = make_unique<std::unordered_map<string, shared_ptr<Card>>>();
}

shared_ptr<Card> GameBoard::assign(string slotid, Card &&card) {
    auto card_ptr = make_shared<Card>(card);
    single_slots_->insert_or_assign(slotid, card_ptr);
    return card_ptr;
}

shared_ptr<Card> GameBoard::get(string slotid) {
    return (*single_slots_)[slotid];
}

void GameBoard::remove(string slotid) {
    if (auto card = (*single_slots_)[slotid]) {
        view->removeCardView(slotid);
        single_slots_->erase(slotid);
    }
}

shared_ptr<Card> GameBoard::push(string slotid, Card &&card) {
    auto card_ptr = make_shared<Card>(card);
    auto stack = (*stack_slots_)[slotid].get();
    if (stack == nullptr) {
        auto stack_ptr = make_shared<vector<shared_ptr<Card>>>();
        stack = stack_ptr.get();
        (*stack_slots_)[slotid] = stack_ptr;

        auto stackWidget = StackWidget();
        stackWidget.addChild(CardView::ForCard(card_ptr));
        view->addCardView(slotid, stackWidget);
    } else {
        auto widget = view->getCardView<StackWidget>(slotid);
        widget->addChild(CardView::ForCard(card_ptr));
    }

    stack->emplace_back(card_ptr);
    return card_ptr;
}

shared_ptr<Card> GameBoard::find(string slotid, int idx) {
    auto stack = (*stack_slots_)[slotid].get();
    if (stack == nullptr) {
        return nullptr;
    }

    return (*stack)[idx];
}

void GameBoard::pull(string slotid, int idx) {
    auto stack = (*stack_slots_)[slotid].get();
    if (stack == nullptr) {
        return;
    }

    view->removeCardView(slotid, idx);
    stack->erase(stack->begin() + idx);
}

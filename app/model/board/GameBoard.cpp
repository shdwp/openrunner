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

void GameBoard::luaRegister(luabridge::Namespace ns) {
    ns
            .beginClass<GameBoard>("GameBoard")
            .addFunction("assign", &GameBoard::assign)
            .addFunction("remove", &GameBoard::remove)
            .addFunction("push", &GameBoard::push)
            .addFunction("pull", &GameBoard::pull)
            .endClass();

}

Card* GameBoard::assign(const string& slotid, const Card &card) {
    auto card_ptr = make_shared<Card>(card);
    single_slots_->insert_or_assign(slotid, card_ptr);

    auto card_view = CardView::ForCard(card_ptr);
    view->addCardView(slotid, card_view);

    return card_ptr.get();
}

Card* GameBoard::get(const string& slotid) {
    return (*single_slots_)[slotid].get();
}

void GameBoard::remove(const string& slotid) {
    if (auto card = (*single_slots_)[slotid]) {
        view->removeCardView(slotid);
        single_slots_->erase(slotid);
    }
}

Card *GameBoard::push(const string& slotid, const Card &card) {
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
    return card_ptr.get();
}

Card *GameBoard::find(const string& slotid, int idx) {
    auto stack = (*stack_slots_)[slotid].get();
    if (stack == nullptr) {
        return nullptr;
    }

    return (*stack)[idx].get();
}

void GameBoard::pull(const string& slotid, int idx) {
    auto stack = (*stack_slots_)[slotid].get();
    if (stack == nullptr) {
        return;
    }

    view->removeCardView(slotid, idx);
    stack->erase(stack->begin() + idx);
}


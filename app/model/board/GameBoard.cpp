//
// Created by shdwp on 5/21/2020.
//

#include "GameBoard.h"
#include "../../view/widgets/StackWidget.h"

GameBoard::GameBoard() {
    this->views = make_shared<vector<shared_ptr<GameBoardView>>>();

    stack_slots_ = make_unique<std::unordered_map<string, shared_ptr<vector<shared_ptr<Card>>>>>();
    single_slots_ = make_unique<std::unordered_map<string, shared_ptr<Card>>>();
}

shared_ptr<GameBoardView> GameBoard::findViewFor(const string &slotid) const {
    for (auto &view : *views) {
        if (view->hasSlot(slotid)) {
            return view;
        }
    }

    return nullptr;
}

Card* GameBoard::assign(const string& slotid, const Card &card) {
    auto card_ptr = make_shared<Card>(card);
    single_slots_->insert_or_assign(slotid, card_ptr);

    if (auto view = findViewFor(slotid)) {
        auto card_view = view->addSlotView(slotid, CardView::ForCard(card_ptr));
        UILayer::registerSceneEntity(card_view);
    }

    return card_ptr.get();
}

Card* GameBoard::get(const string& slotid) {
    return (*single_slots_)[slotid].get();
}

void GameBoard::remove(const string& slotid) {
    if (auto card = (*single_slots_)[slotid]) {
        if (auto view = findViewFor(slotid)) {
            if (auto card_view = view->getSlotView<Entity>(slotid)) {
                UILayer::unregisterSceneEntity(card_view);
                view->removeSlotView(slotid);
            }
        }

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

        if (auto view = findViewFor(slotid)) {
            auto stack_widget = view->addSlotView(slotid, StackWidget());
            auto card_view = stack_widget->addChild(CardView::ForCard(card_ptr));
            UILayer::registerSceneEntity(card_view);
        }
    } else if (auto view = findViewFor(slotid)) {
        auto widget = view->getSlotView<StackWidget>(slotid);
        auto card_view_ptr = widget->addChild(CardView::ForCard(card_ptr));
        UILayer::registerSceneEntity(card_view_ptr);
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

    if (auto view = findViewFor(slotid)) {
        if (idx == -1) {
            if (auto card_view = view->getSlotView<Entity>(slotid)) {
                view->removeSlotView(slotid);
            }

            stack_slots_->erase(slotid);
        } else {
            if (auto stack_widget = view->getSlotView<StackWidget>(slotid)) {
                auto card_view = stack_widget->childAt(idx);
                stack_widget->removeChild(idx);
                UILayer::unregisterSceneEntity(card_view);
            }

            stack->erase(stack->begin() + idx);
        }
    }
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


//
// Created by shdwp on 5/21/2020.
//

#include "GameBoard.h"
#include "../../view/widgets/StackWidget.h"
#include "../../view/board/CardDeckView.h"

GameBoard::GameBoard():
        views(make_shared<vector<shared_ptr<GameBoardView>>>()),
        cards_(make_unique<std::unordered_map<string, vector<shared_ptr<Card>>>>())
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

/*
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
    shared_ptr<CardView> card_view_ptr;
    auto stack = (*stack_slots_)[slotid].get();
    auto view = findViewFor(slotid);
    shared_ptr<StackWidget> stack_widget;

    if (view == nullptr) {
        return nullptr;
    }

    if (stack == nullptr) {
        auto stack_ptr = make_shared<vector<shared_ptr<Card>>>();
        stack = stack_ptr.get();
        (*stack_slots_)[slotid] = stack_ptr;

        stack_widget = view->addSlotView(slotid, StackWidget());
    } else {
        stack_widget = view->getSlotView<StackWidget>(slotid);
    }

    card_view_ptr = stack_widget->addChild(CardView::ForCard(card_ptr));
    stack_widget->update();

    if (attachments_slot.length() != 0) {
        auto x = card_view_ptr->position.x;
        auto zmax = card_view_ptr->position.z;
        auto zmin = -0.2f;
        auto bbox = glm::vec4(x, zmax, x, zmin);

        view->addSlot(attachments_slot, glm::vec3(0.f), bbox);
        auto attachments_widget = view->addSlotView(attachments_slot, StackWidget());

        attachments_widget->orientation = StackWidgetOrientation_Vertical;
        attachments_widget->alignment = StackWidgetAlignment_Max;
        attachments_widget->addChild(CardView::ForCard(card_ptr));
        attachments_widget->addChild(CardView::ForCard(card_ptr));

    UILayer::registerSceneEntity(card_view_ptr);
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
*/

void GameBoard::luaRegister(luabridge::Namespace ns) {
    ns
            .beginClass<GameBoard>("GameBoard")
            .addFunction("insertCard", &GameBoard::insert<Card, CardView>)
            .addFunction("insertDeck", &GameBoard::insert<CardDeck, CardDeckView>)
            .endClass();

}


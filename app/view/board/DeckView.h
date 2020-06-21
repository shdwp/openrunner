//
// Created by shdwp on 6/4/2020.
//

#ifndef OPENRUNNER_DECKVIEW_H
#define OPENRUNNER_DECKVIEW_H

#include <ui/UILayer.h>
#include <LuaBridge/RefCountedPtr.h>
#include "../../model/card/Deck.h"
#include "CardView.h"

class DeckView: public CardView {
private:
    luabridge::RefCountedPtr<Deck> deck_;
    glm::mat4 uiTransform_;

public:
    using CardView::CardView;

    explicit DeckView(luabridge::RefCountedPtr<Deck> deck, const shared_ptr<Model>& model);

    static DeckView For(luabridge::RefCountedPtr<Deck> deck);

    [[nodiscard]] Deck *getUnownedDeckPtr() const { return deck_.get(); }

    string debugDescription() override { return format("{} DeckView {}", CardView::debugDescription(), deck_->size()); }

    void *itemPointer() override { return deck_.get(); }

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_DECKVIEW_H

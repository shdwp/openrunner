//
// Created by shdwp on 6/7/2020.
//

#ifndef OPENRUNNER_ZOOMCARDVIEW_H
#define OPENRUNNER_ZOOMCARDVIEW_H


#include "CardView.h"

class ZoomCardView: public CardView {
public:
    string text = "";

    using CardView::CardView;

    void setCard(luabridge::RefCountedPtr<Card> card, const string &description);

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_ZOOMCARDVIEW_H

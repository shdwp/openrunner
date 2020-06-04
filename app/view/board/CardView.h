//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDVIEW_H
#define OPENRUNNER_CARDVIEW_H


#include <ui/UILayer.h>
#include "SlotView.h"
#include "../../model/card/Card.h"

class CardView: public SlotView, public UIInteractable {
protected:
    shared_ptr<Card> card_;
    glm::mat4 uiTransform_ = glm::mat4(0.f);

public:
    using SlotView::SlotView;
    explicit CardView(shared_ptr<Card> card, const shared_ptr<Model>& model);
    // explicit CardView(shared_ptr<Model> model): SlotView(model) { }

    static shared_ptr<Model> SharedModel;
    static CardView For(shared_ptr<Card> card);

    string debugDescription() override { return format("{} CardView {}, {}", Entity::debugDescription(), card_->uid, card_->faceup); };

    glm::vec4 getArea(const Camera &cam) override;

    void clicked(glm::vec3 pos) override;

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDVIEW_H

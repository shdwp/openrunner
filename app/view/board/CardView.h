//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDVIEW_H
#define OPENRUNNER_CARDVIEW_H


#include <ui/UILayer.h>
#include "SlotView.h"
#include "../../model/card/Card.h"

class CardView: public SlotView, public UIInteractable {
private:
    shared_ptr<Card> card_;
    glm::mat4 uiTransform_;

public:
    using SlotView::SlotView;
    explicit CardView(shared_ptr<Card> card, const shared_ptr<Model>& model);

    static shared_ptr<Model> SharedModel;
    static CardView ForCard(shared_ptr<Card> card);

    glm::vec4 getArea(const Camera &cam) override;

    void clicked(glm::vec3 pos) override;

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDVIEW_H

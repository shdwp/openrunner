//
// Created by shdwp on 5/22/2020.
//

#ifndef OPENRUNNER_CARDVIEW_H
#define OPENRUNNER_CARDVIEW_H


#include <engine/Entity.h>
#include "../../model/card/Card.h"

class CardView: public Entity {
private:
    shared_ptr<Card> card_;

public:
    string slotid;

    using Entity::Entity;
    explicit CardView(shared_ptr<Card> card, const shared_ptr<Model>& model);

    static shared_ptr<Model> SharedModel;
    static CardView ForCard(shared_ptr<Card> card);

    void update() override;

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_CARDVIEW_H

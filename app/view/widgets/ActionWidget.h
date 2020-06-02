//
// Created by shdwp on 6/1/2020.
//

#ifndef OPENRUNNER_ACTIONWIDGET_H
#define OPENRUNNER_ACTIONWIDGET_H


#include <engine/Entity.h>
#include <render/Label.h>

class ActionWidget: public Entity {
private:
    string text;

public:
    ActionWidget();

    void setText(const string& text) {
        this->text = text;
    }

    void draw(glm::mat4 transform) override;
};


#endif //OPENRUNNER_ACTIONWIDGET_H

//
// Created by shdwp on 6/16/20.
//

#ifndef OPENRUNNER_OPTIONSELECTWIDGET_H
#define OPENRUNNER_OPTIONSELECTWIDGET_H

#include <engine/Entity.h>
#include <render/Label.h>
#include <ui/UILayer.h>

class OptionInteractable: public UIInteractable {
public:
    int index;
    glm::vec4 a, b;
    glm::mat4 transform;

    std::tuple<glm::vec4, glm::vec4, int> interactableArea() override {
        return std::tuple(transform * a, transform * b, 10);
    }
};

class OptionSelectWidget: public Entity {
private:
    unique_ptr<vector<shared_ptr<OptionInteractable>>> interactables_ = make_unique<vector<shared_ptr<OptionInteractable>>>();
    shared_ptr<Font> font_;

public:
    OptionSelectWidget(shared_ptr<Font> font): Entity(), font_(font) {}

    void draw(glm::mat4 transform) override;

    void setOptions(vector<string> options);
};


#endif //OPENRUNNER_OPTIONSELECTWIDGET_H

//
// Created by shdwp on 6/16/20.
//

#ifndef OPENRUNNER_OPTIONSELECTWIDGET_H
#define OPENRUNNER_OPTIONSELECTWIDGET_H

#include <engine/Entity.h>
#include <render/Label.h>

class OptionSelectWidget: public Entity {
private:
    unique_ptr<vector<string>> options_ = make_unique<vector<string>>();
    shared_ptr<Font> font_;

public:
    OptionSelectWidget(shared_ptr<Font> font): Entity(), font_(font) {}

    void setOptions(vector<string> options);

    void update() override;

    void draw(glm::mat4 transform) override;

public:
};


#endif //OPENRUNNER_OPTIONSELECTWIDGET_H
